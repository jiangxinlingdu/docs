' XLS_to_TAB_Single.vbs
'
' Converts an Excel workbook to a comma-separated text file.  Requires Microsoft Excel.
' Usage:
'  WScript XLS_to_TAB_Single.vbs <input file> <output file>

' XlFileFormat
Const xlUnicodeText = 42 ' Tab delimited text file
' MsoAutomationSecurity
Const msoAutomationSecurityForceDisable = 3

Dim app, doc, fso
Set fso = CreateObject("Scripting.FileSystemObject")
If fso.FileExists(WScript.Arguments(1)) Then fso.DeleteFile WScript.Arguments(1)
Set app = CreateObject("Excel.Application")

On Error Resume Next

app.DisplayAlerts = False
mso = app.AutomationSecurity
app.AutomationSecurity = msoAutomationSecurityForceDisable
Err.Clear

Set doc = app.Workbooks.Open(WScript.Arguments(0), False, True)
If Err = 0 Then
	doc.SaveAs WScript.Arguments(1), xlUnicodeText
	doc.Close False
End If

app.AutomationSecurity = mso
app.Quit