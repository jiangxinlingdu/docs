' PPT_to_TXT.vbs
'
' Extracts plain text from a PowerPoint document.  Requires Microsoft PowerPoint.
' Usage:
'  WScript PPT_to_TXT.vbs <input file> <output file>

' OpenTextFile iomode
Const ForAppending = 8
' MsoAutomationSecurity
Const msoAutomationSecurityForceDisable = 3

Dim app, doc, fso, tgtFile
Set fso = CreateObject("Scripting.FileSystemObject")
If fso.FileExists(WScript.Arguments(1)) Then fso.DeleteFile WScript.Arguments(1)
Set app = CreateObject("Powerpoint.Application")

On Error Resume Next

app.DisplayAlerts = False
mso = app.AutomationSecurity
app.AutomationSecurity = msoAutomationSecurityForceDisable
Err.Clear

Set doc = app.Presentations.Open(WScript.Arguments(0), True, , False)
If Err = 0 Then
	Set tgtFile = fso.OpenTextFile(WScript.Arguments(1), ForAppending, True)
	For Each sld In doc.Slides
		For Each shp In sld.Shapes
			If shp.HasTextFrame Then
				If shp.TextFrame.HasText Then tgtFile.WriteLine(shp.TextFrame.TextRange.Text)
			End If
		Next
		For Each shp In sld.NotesPage.Shapes
			If shp.HasTextFrame Then
				If shp.TextFrame.HasText Then tgtFile.WriteLine(shp.TextFrame.TextRange.Text)
			End If
		Next
		For Each cmt In sld.Comments
			tgtFile.WriteLine(cmt.Author & vbTAB & cmt.DateTime & vbTAB & cmt.Text)
		Next
	Next
	tgtFile.Close
	doc.Close
End If

app.AutomationSecurity = mso
app.Quit