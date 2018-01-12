' MDB_to_CSV.vbs
'
' Converts an Access table to a comma-separated text file.  Requires Microsoft Access.
' Usage:
'  WScript MDB_to_CSV.vbs <input file> <output file>

' AcTextTransferType
Const acExportDelim = 2
' OpenTextFile iomode
Const ForReading = 1
Const ForAppending = 8

Dim app, fso, tgtFile, tmpFile
Dim tmpNames()
Set fso = CreateObject("Scripting.FileSystemObject")
If fso.FileExists(WScript.Arguments(1)) Then fso.DeleteFile WScript.Arguments(1)
Set app = CreateObject("Access.Application")

On Error Resume Next

app.OpenCurrentDatabase WScript.Arguments(0)
app.Visible = False
If Err = 0 Then
	I = 0
	For Each obj In app.CurrentData.AllTables
		If Left(obj.Name, 4) <> "MSys" Then I = I + 1
	Next
	tmpCount = I
	ReDim tmpNames(I)
	Set tgtFile = fso.OpenTextFile(WScript.Arguments(1), ForAppending, True)
	I = 0
	For Each obj In app.CurrentData.AllTables
		If Left(obj.Name, 4) <> "MSys" Then
			I = I + 1
			tgtFile.WriteLine """TABLE " & obj.Name & """"
			tmpNames(I) = fso.GetSpecialFolder(2) & "\" & fso.GetTempName
			app.DoCmd.TransferText acExportDelim, "", obj.Name, tmpNames(I)
			Set tmpFile = fso.OpenTextFile(tmpNames(I), ForReading)
			tgtFile.Write tmpFile.ReadAll
			tmpFile.Close
			If I <> tmpCount Then tgtFile.WriteLine
		End If
	Next
	tgtFile.Close
	app.CloseCurrentDatabase
End If

app.Quit
For I = 1 to tmpCount
	If fso.FileExists(tmpNames(I)) Then fso.DeleteFile tmpNames(I)
Next