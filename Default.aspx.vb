Imports System.Configuration
Imports System.Data.SqlClient
Imports System.Drawing
Imports System.Globalization
Imports System.Web.Script.Serialization
Imports System.Web.Script.Services
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports Newtonsoft.Json

Public Class _Default
    Inherits System.Web.UI.Page
    Dim employeeData As DataTable
    Shared gv As New GridView()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim dataAccess As New DataAccess(connectionString)
        'FetchEmployeeData()

        '' Create an Employee object with sample data
        'Dim employee As New Employee()
        'employee.UniqueId = 123
        'employee.FirstName = "John"
        'employee.LastName = "Doe"
        'employee.BirthDate = New DateTime(2024, 2, 10)
        'employee.JoinDate = DateTime.Now
        'employee.Designation = "Manager"

        ''Call the InsertOrUpdateEmployee method
        'dataAccess.InsertOrUpdateEmployee(employee)
        'If Not IsPostBack Then
        '    ' Call a method to fetch data from your data source
        '    employeeData = FetchEmployeeData()
        '    gv = Me.GridViewEmployees
        '    ' Check if data is retrieved successfully
        '    If employeeData IsNot Nothing AndAlso employeeData.Rows.Count > 0 Then
        '        ' Bind the retrieved data to the GridView control
        '        GridViewEmployees.DataSource = employeeData
        '        GridViewEmployees.DataBind()
        '    Else
        '        ' If no data is available, display a message or handle it as needed
        '        ' For example, you can display a message in a label or log an error
        '        'lblMessage.Text = "No data available."
        '    End If
        'End If



        ' Use dataAccess object to interact with the database
    End Sub
    <WebMethod>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function UpdateInsertRecord(ByVal empObj As Employee) As String
        'Public Shared Function UpdateInsertRecord(FirstName As String, LastName As String, BirthDate As String, JoinDate As String, Designation As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim result As String = ""
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                'Dim parsedBirthDate As DateTime
                'Dim parsedJoinDate As DateTime


                ' Insert into database using stored procedure
                Using cmd As New SqlCommand("Update_Insert_Employee", connection)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@UniqueId", empObj.UniqueId)
                    cmd.Parameters.AddWithValue("@FirstName", empObj.FirstName)
                    cmd.Parameters.AddWithValue("@LastName", empObj.LastName)
                    cmd.Parameters.AddWithValue("@BirthDate", empObj.BirthDate)
                    cmd.Parameters.AddWithValue("@JoinDate", empObj.JoinDate)
                    cmd.Parameters.AddWithValue("@Designation", empObj.Designation)
                    cmd.Parameters.AddWithValue("@companyid", empObj.companyid)
                    'cmd.Parameters.AddWithValue("@CompanyName", empObj.CompanyName)
                    cmd.ExecuteNonQuery()
                End Using

                result = "success"
            End Using
        Catch ex As Exception
            ' Handle exceptions
            result = ex.Message
        End Try

        Return result
    End Function

    <WebMethod>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function UpdateComanyRecord(ByVal comObj As Company) As String
        'Public Shared Function UpdateInsertRecord(FirstName As String, LastName As String, BirthDate As String, JoinDate As String, Designation As String) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim result As String = ""
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                'Dim parsedBirthDate As DateTime
                'Dim parsedJoinDate As DateTime


                ' Insert into database using stored procedure
                Using cmd As New SqlCommand("EditCompany", connection)
                    cmd.CommandType = CommandType.StoredProcedure
                    cmd.Parameters.AddWithValue("@companyid", comObj.companyid)
                    cmd.Parameters.AddWithValue("@CompanyName", comObj.CompanyName)
                    cmd.Parameters.AddWithValue("@address", comObj.address)
                    cmd.Parameters.AddWithValue("@CompanyType", comObj.companyType)
                    'cmd.Parameters.AddWithValue("@CompanyName", empObj.CompanyName)
                    cmd.ExecuteNonQuery()
                End Using

                result = "success"
            End Using
        Catch ex As Exception
            ' Handle exceptions
            result = ex.Message
        End Try

        Return result
    End Function


    '<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>

    'Public Shared Function InsertRecord(FirstName As String, LastName As String, BirthDate As String, JoinDate As String, Designation As String) As String

    '<WebMethod()>
    '<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    'Public Shared Function InsertRecord(FirstName As String, LastName As String, BirthDate As String, JoinDate As String, Designation As String) As String

    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function InsertRecord(ByVal empObj As Employee) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim result As String = ""
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                'Dim parsedBirthDate As DateTime
                'Dim parsedJoinDate As DateTime
                'Dim birthDate As DateTime = DateTime.ParseExact(empObj.BirthDate, "dd-MM-yyyy", CultureInfo.InvariantCulture)
                'Dim joinDate As DateTime = DateTime.ParseExact(empObj.JoinDate, "dd-MM-yyyy", CultureInfo.InvariantCulture)


                ' Insert into database using stored procedure
                Using cmd As New SqlCommand("Insert_Employee", connection)
                    cmd.CommandType = CommandType.StoredProcedure
                    'cmd.Parameters.AddWithValue("@UniqueId", empObj.UniqueId)

                    cmd.Parameters.AddWithValue("@FirstName", empObj.FirstName)
                    cmd.Parameters.AddWithValue("@LastName", empObj.LastName)
                    cmd.Parameters.AddWithValue("@BirthDate", empObj.BirthDate)

                    cmd.Parameters.AddWithValue("@JoinDate", empObj.JoinDate)
                    cmd.Parameters.AddWithValue("@Designation", empObj.Designation)
                    cmd.Parameters.AddWithValue("@companyid", empObj.companyid)
                    'cmd.Parameters.AddWithValue("@CompanyName", empObj.CompanyName)
                    cmd.ExecuteNonQuery()
                End Using
                'FetchEmployeeData()

                result = "success"
            End Using
        Catch ex As Exception
            ' Handle exceptions
            result = ex.Message
        End Try

        Return result
    End Function

    <WebMethod>
    Public Shared Function countingtotalrecord(dataType As String) As Integer
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim totalCount As Integer = 0
        Dim query As String = ""
        If dataType = "Employee" Then
            query = "SELECT COUNT(*) FROM Employees_View;"
        ElseIf dataType = "Archive" Then
            query = "SELECT COUNT(*) FROM Employee_Archive;"
        End If




        Using connection As New SqlConnection(connectionString)
            Using command As New SqlCommand(query, connection)
                Try
                    connection.Open()
                    totalCount = Convert.ToInt32(command.ExecuteScalar())
                Catch ex As Exception
                    ' Handle exceptions
                End Try
            End Using
        End Using

        Return totalCount
    End Function


    'Dim query As String = "SELECT UniqueId,CONCAT(FirstName
    <WebMethod>
    Public Shared Function FetchEmployeeData(pageIndex As Integer, pageSize As Integer) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString

        'Dim query As String = "SELECT UniqueId,CONCAT(FirstName, ' ', LastName) AS Name,DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW, BirthDate)),'%Y')+0 AS Age,CONVERT(VARCHAR, JoinDate, 106) AS JoinDate,Designation
        ''FROM Employees_View;"
        'Dim query As String = "SELECT UniqueId, CONCAT(FirstName, ' ', LastName) AS Name, " &
        '              "CASE WHEN MONTH(GETDATE()) < MONTH(BirthDate) " &
        '              "OR (MONTH(GETDATE()) = MONTH(BirthDate) AND DAY(GETDATE()) < DAY(BirthDate)) " &
        '              "THEN DATEDIFF(YEAR, BirthDate, GETDATE()) - 1 " &
        '              "ELSE DATEDIFF(YEAR, BirthDate, GETDATE()) END AS Age, " &
        '              "CONVERT(VARCHAR, JoinDate, 106) AS JoinDate, " &
        '              "Designation " &
        '              "FROM Employees_View " &
        '              "ORDER BY JoinDate DESC " &
        '              "OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;"
        'Dim query As String = "SELECT UniqueId, CONCAT(FirstName, ' ', LastName) AS Name, DATE_FORMAT(FROM_DAYS(DATEDIFF(NOW(), BirthDate)), '%Y')+0 AS Age, CONVERT(VARCHAR, JoinDate, 106) AS JoinDate, Designation FROM Employees_View;"
        'Dim query As String = "SELECT UniqueId, CONCAT(FirstName, ' ', LastName) AS Name, " &
        '                  "CASE WHEN MONTH(GETDATE()) < MONTH(BirthDate) " &
        '                  "OR (MONTH(GETDATE()) = MONTH(BirthDate) AND DAY(GETDATE()) < DAY(BirthDate)) " &
        '                  "THEN DATEDIFF(YEAR, BirthDate, GETDATE()) - 1 " &
        '                  "ELSE DATEDIFF(YEAR, BirthDate, GETDATE()) END AS Age, " &
        '                  "CONVERT(VARCHAR, JoinDate, 106) AS JoinDate, " &
        '                  "Designation " &
        '                  "FROM Employees_View AS E " &
        '                  "CROSS JOIN (SELECT COUNT(*) AS TotalCount FROM Employees_View) AS TC " &
        '                  "ORDER BY E.JoinDate DESC " &
        '                  "OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;"

        'Using cmd As New SqlCommand("GetEmployees", connection)
        '    cmd.CommandType = CommandType.StoredProcedure
        '    cmd.Parameters.AddWithValue("@Offset", pageIndex) ' Provide the value for offset
        '    cmd.Parameters.AddWithValue("@PageSize", pageSize) ' Provide the value for pageSize
        '    Dim reader As SqlDataReader = cmd.ExecuteReader()
        '    While reader.Read()
        '        ' Access the columns returned by the stored procedure
        '        Dim uniqueId As Integer = Convert.ToInt32(reader("UniqueId"))
        '        Dim name As String = Convert.ToString(reader("Name"))
        '        Dim age As Integer = Convert.ToInt32(reader("Age"))
        '        Dim joinDate As String = Convert.ToString(reader("JoinDate"))
        '        Dim designation As String = Convert.ToString(reader("Designation"))

        '        ' Process the data as needed
        '        ' For example, you can populate a list or display the data on the UI
        '    End While

        '    reader.Close()
        'End Using

        'cmd.ExecuteNonQuery()



        Dim employeeData As New DataTable()

            Using connection As New SqlConnection(connectionString)
                Using command As New SqlCommand("GetEmployees", connection)
                    command.CommandType = CommandType.StoredProcedure

                    command.Parameters.AddWithValue("@Offset", (pageIndex - 1) * pageSize)
                    command.Parameters.AddWithValue("@PageSize", pageSize)
                    Try
                    connection.Open()
                    Dim reader As SqlDataReader = Command.ExecuteReader()
                    employeeData.Load(reader)
                Catch ex As Exception
                    ' Handle exceptions, log errors, or display error messages as needed
                    ' For example:
                    ' lblMessage.Text = "An error occurred while fetching data."
                    ' LogError(ex.Message)
                End Try
            End Using
        End Using
        Return JsonConvert.SerializeObject(employeeData, Newtonsoft.Json.Formatting.Indented)
        'Return employeeData
    End Function
    'Protected Sub GridViewEmployees_RowDeleting(ByVal sender As Object, ByVal e As GridViewDeleteEventArgs) Handles GridViewEmployees.RowDeleting
    '    '' Add your logic here to handle the row deletion


    '    '' Extract the unique ID of the employee from the row being deleted
    '    ''m uniqueId As Integer = Convert.ToInt32(GridViewEmployees.DataKeys(e.RowIndex).Value)
    '    'Dim uniqueId As Integer = Convert.ToInt32(e.RowIndex)
    '    'Dim dataAccess As New DataAccess(connectionString)


    '    '' Call the DeleteEmployee method passing the unique ID
    '    'dataAccess.DeleteEmployee(uniqueId)
    'End Sub

    '
    '<ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    <WebMethod>
    Public Shared Function FetchArchiveData(pageIndex As Integer, pageSize As Integer) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim employeeData As New DataTable()

        Using connection As New SqlConnection(connectionString)
            Using command As New SqlCommand("GetArchiveData", connection)
                command.CommandType = CommandType.StoredProcedure

                command.Parameters.AddWithValue("@Offset", (pageIndex - 1) * pageSize)
                command.Parameters.AddWithValue("@PageSize", pageSize)
                Try
                    connection.Open()
                    Dim reader As SqlDataReader = command.ExecuteReader()
                    employeeData.Load(reader)
                Catch ex As Exception
                    ' Handle exceptions, log errors, or display error messages as needed
                    ' For example:
                    ' lblMessage.Text = "An error occurred while fetching data."
                    ' LogError(ex.Message)
                End Try
            End Using
        End Using
        Return JsonConvert.SerializeObject(employeeData, Newtonsoft.Json.Formatting.Indented)
    End Function
    <WebMethod>
    Public Shared Function DeleteRecord(ByVal id As Integer) As String
        Dim x As String = ""
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim connection As SqlConnection =
            New SqlConnection(connectionString)
        connection.Open()
        Try
            Dim command As SqlCommand =
                New SqlCommand("DeleteEmployee", connection)
            command.CommandType = CommandType.StoredProcedure

            command.Parameters.Add("@UniqueId", id)
            x = "success"

            command.ExecuteNonQuery()
            'FetchEmployeeData()
        Catch ex As Exception
            Console.WriteLine(ex.Message)
            Throw
        Finally
            connection.Close()
        End Try
        Return x


        ''Dim connectionString As String = connectionString
        'Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        'Dim result As String = ""
        'Try
        '    Using connection As New SqlConnection(connectionString)
        '        Using command As New SqlCommand("DeleteEmployee", connection)
        '            connection.Open()
        '            command.CommandType = CommandType.StoredProcedure
        '            command.Parameters.AddWithValue("@UniqueId", id) ' Assuming your stored procedure parameter is named @ID
        '            command.Connection = connection
        '            command.ExecuteNonQuery()
        '            result = "Record deleted successfully."
        '            Dim page As _Default = TryCast(HttpContext.Current.Handler, _Default)
        '            If page IsNot Nothing Then
        '                Dim employeeData As DataTable = page.FetchEmployeeData()

        '                ' Check if data is retrieved successfully
        '                If employeeData IsNot Nothing AndAlso employeeData.Rows.Count > 0 Then
        '                    ' Bind the retrieved data to the GridView control

        '                    gv.DataSource = employeeData
        '                    gv.DataBind()
        '                End If
        '            End If

        '        End Using
        '    End Using
        'Catch ex As Exception
        '    result = "Error deleting record: " & ex.Message
        'End Try

        '' Execute your delete stored procedure here using id

        'Return result
    End Function

    <WebMethod>
    Public Shared Function DeleteCompany(ByVal companyid As Integer) As String
        Dim x As String = ""
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim connection As SqlConnection =
            New SqlConnection(connectionString)
        connection.Open()
        Try
            Dim command As SqlCommand =
                New SqlCommand("DeleteCompany", connection)
            command.CommandType = CommandType.StoredProcedure

            command.Parameters.Add("@companyid", companyid)
            x = "success"

            command.ExecuteNonQuery()
            'FetchEmployeeData()
        Catch ex As Exception
            Console.WriteLine(ex.Message)
            Throw
        Finally
            connection.Close()
        End Try
        Return x


        ''Dim connectionString As String = connectionString
        'Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        'Dim result As String = ""
        'Try
        '    Using connection As New SqlConnection(connectionString)
        '        Using command As New SqlCommand("DeleteEmployee", connection)
        '            connection.Open()
        '            command.CommandType = CommandType.StoredProcedure
        '            command.Parameters.AddWithValue("@UniqueId", id) ' Assuming your stored procedure parameter is named @ID
        '            command.Connection = connection
        '            command.ExecuteNonQuery()
        '            result = "Record deleted successfully."
        '            Dim page As _Default = TryCast(HttpContext.Current.Handler, _Default)
        '            If page IsNot Nothing Then
        '                Dim employeeData As DataTable = page.FetchEmployeeData()

        '                ' Check if data is retrieved successfully
        '                If employeeData IsNot Nothing AndAlso employeeData.Rows.Count > 0 Then
        '                    ' Bind the retrieved data to the GridView control

        '                    gv.DataSource = employeeData
        '                    gv.DataBind()
        '                End If
        '            End If

        '        End Using
        '    End Using
        'Catch ex As Exception
        '    result = "Error deleting record: " & ex.Message
        'End Try

        '' Execute your delete stored procedure here using id

        'Return result
    End Function



    <WebMethod()>
    Public Shared Function FetcCompanyData() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim query As String = "SELECT companyid,CompanyName, address,companyType FROM CompanyTable;"

        Dim employeeData As New DataTable()

        Using connection As New SqlConnection(connectionString)
            Using command As New SqlCommand(query, connection)
                Try
                    connection.Open()
                    Dim reader As SqlDataReader = command.ExecuteReader()
                    employeeData.Load(reader)
                Catch ex As Exception
                    ' Handle exceptions, log errors, or display error messages as needed
                    ' For example:
                    ' lblMessage.Text = "An error occurred while fetching data."
                    ' LogError(ex.Message)
                End Try
            End Using
        End Using

        Return JsonConvert.SerializeObject(employeeData, Newtonsoft.Json.Formatting.Indented)
    End Function

    <WebMethod()>
    Public Shared Function FetcCompanyList() As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim query As String = "SELECT companyid,CompanyName FROM CompanyTable;"

        Dim employeeData As New DataTable()

        Using connection As New SqlConnection(connectionString)
            Using command As New SqlCommand(query, connection)
                Try
                    connection.Open()
                    Dim reader As SqlDataReader = command.ExecuteReader()
                    employeeData.Load(reader)
                Catch ex As Exception
                    ' Handle exceptions, log errors, or display error messages as needed
                    ' For example:
                    ' lblMessage.Text = "An error occurred while fetching data."
                    ' LogError(ex.Message)
                End Try
            End Using
        End Using

        Return JsonConvert.SerializeObject(employeeData, Newtonsoft.Json.Formatting.Indented)
    End Function


    Public Sub InsertCustomer()
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim connection As SqlConnection =
            New SqlConnection(connectionString)
        connection.Open()
        Try
            Dim command As SqlCommand =
                New SqlCommand("DeleteEmployee", connection)
            command.CommandType = CommandType.StoredProcedure

            command.Parameters.Add("@UniqueId", ID)

            'Dim x = command.ExecuteNonQuery().ToString()


        Catch ex As Exception
            Console.WriteLine(ex.Message)
            Throw
        Finally
            connection.Close()
        End Try
    End Sub

    <WebMethod()>
    Public Shared Function GetByID(ByVal UniqueId As Integer) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim connection As SqlConnection = New SqlConnection(connectionString)
        Dim employeeData As New DataTable()
        'Dim result As New Employee ' Change YourRecordType to match your record structure
        Dim result = New With {
                        .UniqueId = 0,
                       .FirstName = "",
                       .LastName = "",
                       .BirthDate = DateTime.MinValue,
                      .JoinDate = DateTime.MinValue,
                      .Designation = "",
                      .companyid = "",
                       .CompanyName = ""
                       }
        'Dim employeeData As New DataTable()
        Try
            connection.Open()
            Dim query As String = "SELECT e.UniqueId, e.FirstName, e.LastName, e.BirthDate, e.JoinDate, e.Designation, c.CompanyName,c.companyid
                 FROM Employee e
               LEFT JOIN RelationalTable ec ON e.UniqueId = ec.empid
               Left Join CompanyTable c ON ec.CompanyID = c.companyid
               WHERE e.UniqueId = @UniqueId;"



            Dim command As SqlCommand = New SqlCommand(query, connection)
            command.Parameters.AddWithValue("@UniqueId", UniqueId) ' Set the value of @UniqueId




            Dim reader As SqlDataReader = command.ExecuteReader()
            employeeData.Load(reader)

            If reader.Read() Then
                ' Map the data from the reader to your record object
                result.UniqueId = Convert.ToInt32(reader("UniqueId"))
                result.FirstName = reader("FirstName").ToString()
                result.LastName = reader("LastName").ToString()
                result.BirthDate = reader("BirthDate")
                result.JoinDate = reader("JoinDate")
                result.Designation = reader("Designation").ToString()
                result.companyid = reader("companyid").ToString()
                result.CompanyName = reader("CompanyName").ToString()
            End If

            reader.Close()
        Catch ex As Exception
            Console.WriteLine(ex.Message)
            ' Handle exceptions as needed
            ' You may want to return an error message
        Finally
            connection.Close()
        End Try

        ' Serialize the result object to JSON and return
        'Return JsonConvert.SerializeObject(Result)
        Dim jsonResult As String = JsonConvert.SerializeObject(result)
        Return jsonResult

    End Function

    <WebMethod()>
    Public Shared Function GetByIDCompany(ByVal companyid As Integer) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim connection As SqlConnection = New SqlConnection(connectionString)
        Dim employeeData As New DataTable()
        'Dim result As New Employee ' Change YourRecordType to match your record structure
        Dim result = New With {
                        .companyid = 0,
                       .CompanyName = "",
                       .address = "",
                       .CompanyType = ""
                       }
        'Dim employeeData As New DataTable()
        Try
            connection.Open()
            Dim query As String = "SELECT companyid, CompanyName,address, CompanyType
                 FROM CompanyTable 
              
               WHERE companyid = @companyid;"



            Dim command As SqlCommand = New SqlCommand(query, connection)
            command.Parameters.AddWithValue("@companyid", companyid) ' Set the value of @UniqueId




            Dim reader As SqlDataReader = command.ExecuteReader()
            'employeeData.Load(reader)

            If reader.Read() Then
                ' Map the data from the reader to your record object
                result.companyid = Convert.ToInt32(reader("companyid"))
                result.CompanyName = reader("CompanyName").ToString()
                result.address = reader("address").ToString()
                result.CompanyType = reader("CompanyType")
                
            End If

            reader.Close()
        Catch ex As Exception
            Console.WriteLine(ex.Message)
            ' Handle exceptions as needed
            ' You may want to return an error message
        Finally
            connection.Close()
        End Try

        ' Serialize the result object to JSON and return
        'Return JsonConvert.SerializeObject(Result)
        Dim jsonResult As String = JsonConvert.SerializeObject(result)
        Return jsonResult

    End Function




    <WebMethod()>
    <ScriptMethod(ResponseFormat:=ResponseFormat.Json)>
    Public Shared Function AddCompanyRecord(ByVal comObj As Company) As String
        Dim connectionString As String = ConfigurationManager.ConnectionStrings("CrudDatabase").ConnectionString
        Dim result As String = ""
        Try
            Using connection As New SqlConnection(connectionString)
                connection.Open()
                'Dim parsedBirthDate As DateTime
                'Dim parsedJoinDate As DateTime
                'Dim birthDate As DateTime = DateTime.ParseExact(empObj.BirthDate, "dd-MM-yyyy", CultureInfo.InvariantCulture)
                'Dim joinDate As DateTime = DateTime.ParseExact(empObj.JoinDate, "dd-MM-yyyy", CultureInfo.InvariantCulture)


                ' Insert into database using stored procedure

                Using cmd As New SqlCommand("Insert_Company", connection)
                    cmd.CommandType = CommandType.StoredProcedure
                    'cmd.Parameters.AddWithValue("@UniqueId", empObj.UniqueId)
                    cmd.Parameters.AddWithValue("@CompanyName", comObj.CompanyName)
                    cmd.Parameters.AddWithValue("@address", comObj.address)
                    cmd.Parameters.AddWithValue("@companyType", comObj.companyType)
                    cmd.ExecuteNonQuery()
                End Using
                'FetchEmployeeData()

                result = "success"
            End Using
        Catch ex As Exception
            ' Handle exceptions
            result = ex.Message
        End Try

        Return result
    End Function


End Class