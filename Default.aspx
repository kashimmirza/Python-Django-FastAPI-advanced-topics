<%@ Page Language="VB" AutoEventWireup="false" CodeBehind="Default.aspx.vb" Inherits="WebApplication1._Default" %>

<!DOCTYPE html>
<html lang="en">
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Crude application</title>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <div class="container">
   
        <%--<h2>Employees Record</h2>--%>
    <button id="toggleDataBtn" type="button" class="btn btn-primary">Archive Data</button>

    
    <button id="addEmployeeBtn" type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">Add New Employee</button>
     <button id="addCompanyBtn" type="button" class="btn btn-primary" data-toggle="modal" data-target="#myCompany">Add Company</button>
      <%--<button id="addlistBtn" type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">Add New Employee</button>--%>
      <button type="button" class="btn btn-primary" id="addlistBtn" style="display: inline-block;" onclick="showComanyList();">showCompanyList</button>
    </div>

   
</head>
<body>
    
    <script type="text/javascript">
        // Load Data in Table when document is ready
        //let uniid;
        //var pageSize=5;
        //let pageNumber = 1;

        //var totalCount;
        
        let totalPage;
        let currentPage = 1;
        let pageSize;
        let DeletedPage = 0;
        let dataType = 'Employee'; 
        var recordsOnCurrentPage = 0;
        var uniqueidComp;
        var selectedCompanyType;
        
        
        $(document).ready(function () {
            pageSize = $('#selectPage').val();
            <%--currentPage = parseInt($('#<%= currentPageHidden.ClientID %>').val());--%>
            pageSize = parseInt(pageSize);
            var companyTypes = ['Private','private','Software', 'Semi Government', 'Government'];
            var ddlCompanyType = $('#companyType');
            ddlCompanyType.empty();
            ddlCompanyType.append($('<option value="">Select Company Type</option>'));

            ////companyTypes.forEach(function (type, index) {
            ////    // Append an option element for each value
            ////    ddlCompanyType.append($('<option></option>').attr('value', index).text(type));
            ////});

            //// Add company types to dropdown list
            $.each(companyTypes, function (index, type) {
                ddlCompanyType.append($('<option></option>').val(type).text(type));
            });

            //var ddlCompanyType = document.getElementById("companyType");

            //// Get the selected value
            //var selectedValue = ddlCompanyType.value;
            // Get the selected value
           /* var selectedValue = $('#companyType').val();*/

            //companyTypes.each(function () {
            //    //if its a select 
            //    if ($(this).is("companyType")) {
            //        //find its selected index using native DOM and do something with it
            //        $(this)[0].selectedIndex;
            //    }
            //});
            
            //$.each(companyList, function (index, companyName) {
            //    ddlCompanyType.append($('<option></option>').val(index).html(companyTypes.[index]));
            //    console.log(typeof companyTypes[index]);
            //});
            var companyList = [];

            fetchCompanyNames();

          
            loadData(); // Load default data
            countingTotalRecordsAndGeneratePagination();

            
            $('#toggleDataBtn').click(function () {
                // Toggle between 'Employee' and 'Archive'
               
                var currentTitle = $('#tableTitle').text().trim();
                dataType = dataType === 'Employee' ? 'Archive' : 'Employee';
                // Toggle button text
                //$(this).text(dataType === 'Employee' ? 'Employee Data' : 'Archive Data');
                $(this).text(dataType === 'Employee' ? 'Archive Data' : 'Employee Data');

                if (dataType === 'Employee') {
                    //$(this).text('')
                    currentPage = 1;
                    
                    $("#addEmployeeBtn").show();
                    $('#tableTitle').text('Employee Records');
                }
                else if (dataType === 'Archive') {
                    currentPage = 1;
                    
                    $('#tableTitle').text('Archive Records');

                    $("#addEmployeeBtn").hide();
                }
                
                
                countingTotalRecordsAndGeneratePagination();
                loadData();
            });

            //$("#submit").click(function () {
            //    const selectedVal = $("#myselection").val();
            //    $('#result')
            //        .text(`The selected value is: ${selectedVal}`);
            //}); 
          
             
            $('#selectPage').change(function () {
                
                var oldPageSize = pageSize; // Store the old page size
                pageSize = parseInt($(this).val());
                var oldPage = Math.ceil((currentPage * oldPageSize) / pageSize); // Calculate old page number based on old page size
                currentPage = oldPage; 
                
                countingTotalRecordsAndGeneratePagination();
                loadData();
            });
            $('#previousButton').click(function () {
                preClick();
            });

            // Bind click event to the next button
            $('#nextButton').click(function () {
                nextClick();
            });
            
        });
          

        function countingTotalRecordsAndGeneratePagination() {
            $.ajax({
                url: "default.aspx/countingtotalrecord",
                type: "POST",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ dataType: dataType }),
                success: function (result) {
                    let totalCount = parseInt(result.d);
                    totalPage = Math.ceil(totalCount / pageSize);
                    console.log(totalPage)
                    generatePaginationButtons();
                    //loadData();
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                }
            });
        }
            
             
            
            $("#addEmployeeBtn").click(function () {
                clearTextBox();
            });

            $("#updateEmployeeBtn").click(function () {
                clearTextBox();
            });
       



        function preClick() {
            //console.log("pre click", pageNumber)
            if (currentPage> 1) {
                /* currentPage -= 1;*/
                currentPage -= 1;
                //AddActive(pageNumber - 1)
                //callData()
                loadData()
                updatePaginationButtonStates();
            }
        }
        function nextClick() {
            console.log("next click")
            if (currentPage< totalPage) {
                currentPage += 1;
               
                loadData()
                updatePaginationButtonStates();
            }
        }
        function generatePaginationButtons() {
            let paginationHtml = '';
            paginationHtml += '<ul class="pagination Archive">';
            paginationHtml += '<li class="page-item' + (currentPage === 1 ? ' disabled' : '') + '" onclick="preClick()">';
            paginationHtml += '</li>';

            var startPage = Math.max(1, currentPage - 4); // Start page index
            var endPage = Math.min(totalPage, startPage + 9); // End page index
            //for (let i = startPage; i <= endPage; i++)
            //var  startPage = Math.max(1, currentPage - 4); // Start page index
            //var  endPage = Math.min(totalPage, startPage + 9); // End page index
            for (let i = 1; i <= totalPage; i++) {
                paginationHtml += '<li id="btnid' + i + '"class="page-item' + (i === currentPage ? ' active' : '') + '"><a class="page-link" onclick="goToPage(' + i + ', \'#btnid' + i + '\')">' + i + '</a></li>';
                
            }

            paginationHtml += '<li class="page-item' + (currentPage === totalPage ? ' disabled' : '') + '" onclick="nextClick()">';
            paginationHtml += '</li>';
            paginationHtml += '</ul>';

            $("#list").html(''); // Clear the existing pagination buttons
            $("#list").append(paginationHtml);
        }

      
        //}
        
        function goToPage(page,btnid) {
            currentPage = page; // Set current page
            $('.pagination li').removeClass('active'); // Remove active class from all buttons
            $('#btnid' + currentPage).addClass('active');
            //$('.pagination li').removeClass('active'); // Remove active class from all buttons
            //$('#btnid' + currentPage).addClass('active');
            //currentPage = page; // Set current page
            //$('.page-item').removeClass('active'); // Remove active class from all buttons
            //$(btnid).attr('class', 'active'); // Add active class to the selected button
            updatePaginationButtonStates();
            loadData(); 
            //$(btnid)
            //loadData(); // Load data for the selected page
        }

        function updatePaginationButtonStates() {
            $('.pagination li').removeClass('active'); 
            $('#btnid' + currentPage).addClass('active'); 
        }
       

        
        // Load Data function
        function loadData() {
            pageSize = parseInt($('#selectPage').val());
            /*pageSize=10*/
            let url = dataType === 'Archive' ? 'default.aspx/FetchArchiveData' : 'default.aspx/FetchEmployeeData';

            
            $.ajax({
                url: url,
                
                type: "POST",
                contentType: "application/json; charset=utf-8",
                /*dataType: "json",*/
                /* data: JSON.stringify({ pageIndex: pageIndex, pageSize: pageSize }),*/
                data: JSON.stringify({ pageIndex: currentPage, pageSize: pageSize }),
                
                success: function (result) {
                    $('.tbody').empty();
                    
                    var employeeData = JSON.parse(result.d);
                    
                    
                    
                   
                    var tableHeader = '<thead><tr><th>Name</th><th>Age</th><th>Join Date</th><th>Designation</th><th>Company Name</th>';
                    if (dataType !== 'Archive') {
                        tableHeader += '<th>Action</th>';
                    }
                   tableHeader += '</tr></thead>';
                    var tableBody = '<tbody>';
                    console.log("employeeObject",employeeData)



                    /*var tableBody = '<tbody>';*/
                    $.each(employeeData, function (index, item) {
                        tableBody += '<tr>';
                        tableBody += '<td>' + item.Name + '</td>';
                        tableBody += '<td>' + item.Age + '</td>';
                        tableBody += '<td>' + item.JoinDate + '</td>';
                        tableBody += '<td>' + item.Designation + '</td>';
                        tableBody += '<td>' + item.CompanyName + '</td>';

                        // Add action column if the dataType is not 'Archive'
                        if (dataType !== 'Archive') {
                            tableBody += '<td><a href="#" onclick="return getbyID(' + item.UniqueId + ')">Edit</a> | <a href="#" onclick="Delete(' + item.UniqueId + ')">Delete</a></td>';
                        }

                        tableBody += '</tr>';
                    });
                    /*tableBody += '<td>' + item.companyName + '</td>';*/
                    tableBody += '</tbody>';
                    var tableHtml = '<table id="employeetable" class="table table-bordered table-hover">' + tableHeader + tableBody + '</table>';
                    //console.log("tableHtml",tableHtml)
                    $('.tbody').html(tableHtml);
                    recordsOnCurrentPage = $(tableBody).find('tr').length;
                    

                    if (dataType === 'Archive') {
                        $('#employeetable th:contains("Action")').remove();
                    }
                    console.log('tablehtml',tableHtml)
                   
                   // $('.tbody').html(tableHtml);
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                }
            });
        }


        function showComanyList() {
            //pageSize = parseInt($('#selectPage').val());
            /*pageSize=10*/
            let url = 'default.aspx/FetcCompanyData';

            
            $.ajax({
                url: url,

                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                /* data: JSON.stringify({ pageIndex: pageIndex, pageSize: pageSize }),*/
                /* data: JSON.stringify({ pageIndex: currentPage, pageSize: pageSize }),*/
                //console.log('hi show data');

                success: function (result) {

                    var companyData = result.d; // Get the data from the response
                    console.log('response', result.d)
                   //document.getElementById("employeeTableContainer").style.display = "none";
                   // document.getElementById("companyTableContainer").style.display = "block";
                    
                    
                   // $('#companyTable tbody').empty();
                    displayEmployeeData(companyData);
                    



                },
                error: function (errormessage) {
                   alert(errormessage.responseText);
                }
            });
            return false;
        }

       

        // Add Data Function
        function Add() {
            
            console.log("hello Add")
            //$('#myModalLabel').attr('Add Employee')
            //companyType: $('#companyType').val()

            
            var empObj = {
                
                FirstName: $('#FirstName').val(),
                LastName: $('#LastName').val(),
                BirthDate: $('#BirthDate').val(),
                JoinDate: $('#JoinDate').val(),
                Designation: $('#Designation').val(),
                /*CompanyName: ${ selectedVal }*/
                companyid: $('#companyNameListdropdown').val()
                
                
            };

         

            //$('#companyNameListdropdown').change(function () {
            //    empObj.CompanyName = JSON.parse($(this).val()); // Update CompanyName property with selected value
            //});
            
           console.log("empObj",empObj)
            $.ajax({
               
                url: "Default.aspx/InsertRecord",
                data: JSON.stringify({ empObj: empObj }),
               // data: JSON.stringify(empObj),
                
                //data: JSON.stringify({ empObj: { FirstName: "fjdk" } }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                dataType: "json",
                success: function (result) {
                    currentPage = 1
                    countingTotalRecordsAndGeneratePagination();
                    generatePaginationButtons();
                   <%-- currentPage = parseInt($('#<%= currentPageHidden.ClientID %>').val());--%>
                   // var totalPageCount = Math.ceil(parseInt(result.d) / pageSize);
                    // Direct the user to the last page

                    //loadData();
                    //currentPage = 1;
                    loadData();

                    clearTextBox();
                    $('#myModal').modal('hide');
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                }
            });
        }


        function AddCompany() {

            console.log("hello Add")
            
            var comObj = {

                CompanyName: $('#CompanyName').val(),
                address: $('#address').val(),
                companyType: $('#companyType').val()
                
            };
            console.log("empObj", comObj)
            $.ajax({

                url: "Default.aspx/AddCompanyRecord",
                data: JSON.stringify({ comObj: comObj }),
                // data: JSON.stringify(empObj),

                //data: JSON.stringify({ empObj: { FirstName: "fjdk" } }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                dataType: "json",
                success: function (result) {
                    
                    console.log('company', comObj);
                    fetchCompanyNames();
                   /* displayEmployeeData(companyData)*/

                    clearTextBoxComp();
            $('#myCompany').modal('hide');
        },
        error: function (errormessage) {
            alert(errormessage.responseText);
        }
    });
        }


        function formatDate(date) {
           

            var parts = date.split('-');
            var year = parseInt(parts[0]);
            var month = parseInt(parts[1]) - 1; // Month is zero-based
            var day = parseInt(parts[2]);

            
            var formattedDate = new Date(year, month, day);
            // Extract the formatted year, month, and day
            var formattedYear = formattedDate.getFullYear();
            var formattedMonth = ('0' + (formattedDate.getMonth() + 1)).slice(-2); // Add leading zero if needed
            var formattedDay = ('0' + formattedDate.getDate()).slice(-2); // Add leading zero if needed

            // Concatenate the formatted parts using the hyphen '-' delimiter
            var formattedDateString = formattedYear + '-' + formattedMonth + '-' + formattedDay;

            // Return the formatted Date object
            return formattedDateString;
        }

       
        function getbyID(UniqueId) {
            uniid = UniqueId
            $('#FirstName').css('border-color', 'lightgrey');
            $('#LastName').css('border-color', 'lightgrey');
            $('#BirthDate').css('border-color', 'lightgrey');
            $('#JoinDate').css('border-color', 'lightgrey');
            $('#Designation').css('border-color', 'lightgrey');
            $('#companyNameListdropdown').css('border-color', 'lightgrey');
            console.log("UniqueId",UniqueId)
            $.ajax({
                url: "Default.aspx/GetByID",
                type: "POST",
                data: JSON.stringify({ UniqueId: UniqueId }),
                contentType: "application/json;charset=UTF-8",
                dataType: "json",
                success: function (result) {
                   // console.log("Result from server = ", result.d)
                    var response = JSON.parse(result.d);
                   console.log('response of updatebyid',response)
                    var joinDate = formatDate(response.JoinDate); // Example Date object
                    var birthDate = formatDate(response.BirthDate);
                    
                   
                    console.log("FirstName", response.FirstName);
                    $('#FirstName').val(response.FirstName);
                    $('#LastName').val(response.LastName);
                   
                    $('#BirthDate').val(birthDate);
                    $('#JoinDate').val(joinDate);
                    $('#Designation').val(response.Designation);
                    $('#companyNameListdropdown').val(response.companyid)
                    /*$('#companyNameListdropdown').text(response.CompanyName);*/
                   /* $('#companyNameListdropdown').val(response.companyid).text(response.CompanyName);*/

                    $('#myModal').modal('show');
                    $('#btnUpdate').show();
                    $('#btnAdd').hide();
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                }
            });
            return false;
        }
       

        function getByIDCompany(companyid) {
            /*uniqueidCompany = uniqueid*/
            uniqueidComp = companyid;
            $('#companyName').css('border-color', 'lightgrey');
            $('#address').css('border-color', 'lightgrey');
            $('#companyType').css('border-color', 'lightgrey');
            
           /* console.log("UniqueId", uniqueidCompany)*/
            $.ajax({
              
                url: "Default.aspx/GetByIDCompany",
                type: "POST",
                data: JSON.stringify({ companyid: companyid }),
                contentType: "application/json;charset=UTF-8",
                dataType: "json",
                success: function (result) {
                    console.log("Result from server = ", result.d)
                    var response = JSON.parse(result.d);
                    console.log('response of updatebyid', response)
                    
                    $('#CompanyName').val(response.CompanyName);
                    $('#address').val(response.address);
                    $('#companyType').val(response.CompanyType);
                    selectedCompanyType = response.CompanyType;
                    /*$('#companyTyp').val(response.CompanyType);*/
                    

                   
                    /*$('#companyNameListdropdown').text(response.CompanyName);*/
                    /* $('#companyNameListdropdown').val(response.companyid).text(response.CompanyName);*/

                    $('#myCompany').modal('show');
                    $('#btnUpdateCompany').show();
                    $('#btnAddCompany').hide();
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                }
            });
            return false;
        }

        // Function for updating employee's record
        function Update() {
            //var res = validate();
            //if (res == false) {
            //    return false;
            //}
           /* $('#myModalLabel').attir('Edit Employee')*/

           /* modalTitle.textContent = "Edit Employee";*/
            console.log("hi update")
            var empObj = {
                UniqueId :uniid,
                FirstName: $('#FirstName').val(),
                LastName: $('#LastName').val(),
                BirthDate: $('#BirthDate').val(),
                JoinDate: $('#JoinDate').val(),
                Designation: $('#Designation').val(),
                Companyid: $('#companyNameListdropdown').val()
            };
            $.ajax({
                url: "Default.aspx/UpdateInsertRecord",
             
                data: JSON.stringify({ empObj: empObj }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                dataType: "json",
                success: function (result) {
                    //loadData(unii);
                    loadData();
                    alert("record has been updated successfully")
                    //loadDate()
                    
                    $('#myModal').modal('hide');
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                }
            });
        }


        function UpdateCompany() {
            //var res = validate();
            //if (res == false) {
            //    return false;
            //}
            /* $('#myModalLabel').attir('Edit Employee')*/

            /* modalTitle.textContent = "Edit Employee";*/
            console.log("hi update")
            var companyObj = {
                companyid: uniqueidComp,
                CompanyName: $('#CompanyName').val(),
                address: $('#address').val(),
                CompanyType: $('#companyType').val(selectedCompanyType)
               
                
                
            };
            $.ajax({
                url: "Default.aspx/UpdateComanyRecord",

                data: JSON.stringify({ companyObj: companyObj }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                dataType: "json",
                success: function (result) {
                    //loadData(unii);
                    showComanyList();
                    alert("record has been updated successfully")
                    //loadDate()

                    $('#mycompany').modal('hide');
                },
                error: function (errormessage) {
                    alert(errormessage.responseText);
                }
            });
        }

        // Function for deleting employee's record
        function Delete(UniqueId) {
            var ans = confirm("Are you sure you want to delete this Record?");
           // loadData();
            if (ans) {
                $.ajax({
                    
                    url: "Default.aspx/DeleteRecord",
                    type: "POST",
                    contentType: "application/json;charset=UTF-8",
                    dataType: "json",
                    data: JSON.stringify({ id: UniqueId }),
                    success: function (result) {
                        DeletedPage = DeletedPage + 1;
                        //AddActivePage();
                        //countingTotalRecordsAndGeneratePagination()
                        //loadData()
                        //recordsOnCurrentPage = 
                        
                        if (DeletedPage === pageSize && currentPage > 1) {
                            currentPage = currentPage - 1;
                        }
                        
                        loadData();
                        recordsOnCurrentPage--;

                        if (recordsOnCurrentPage === 0) {
                            currentPage = currentPage - 1;
                            loadData();
                        }
                        countingTotalRecordsAndGeneratePagination()
                        //generatePaginationButtons()
                        
                        //totalcount
                      
                    },
                    error: function (errormessage) {
                        alert(errormessage.responseText);
                    }
                });
            }
        }

        function DeleteCompany(uniqueidComp) {
            var ans = confirm("Are you sure you want to delete this Record?");
            // loadData();
            if (ans) {
                $.ajax({

                    url: "Default.aspx/DeleteCompany",
                    type: "POST",
                    contentType: "application/json;charset=UTF-8",
                    dataType: "json",
                    data: JSON.stringify({ companyid: uniqueidComp }),
                    success: function (result) {
                      /*  DeletedPage = DeletedPage + 1;*/
                        //AddActivePage();
                        //countingTotalRecordsAndGeneratePagination()
                        //loadData()
                        //recordsOnCurrentPage = 

                        //if (DeletedPage === pageSize && currentPage > 1) {
                        //    currentPage = currentPage - 1;
                        //}

                        showComanyList()
                        //recordsOnCurrentPage--;

                        //if (recordsOnCurrentPage === 0) {
                        //    currentPage = currentPage - 1;
                        //    loadData();
                        //}
                        //countingTotalRecordsAndGeneratePagination()
                        //generatePaginationButtons()

                        //totalcount

                    },
                    error: function (errormessage) {
                        alert(errormessage.responseText);
                    }
                });
            }
        }

        function displayEmployeeData(companyData) {
            var companyData = JSON.parse(companyData);
            console.log('companydata', companyData)
            
           /* tableBody += '<td><a href="#" onclick="return getbyID(' + item.UniqueId + ')">Edit</a> | <a href="#" onclick="Delete(' + item.UniqueId + ')">Delete</a></td>';*/
            /*var table = "<thead><tr><th>CompanyName</th><th>CompanyType</th><th>companyaddress</th></tr></thead><tbody>";*/
            var table = "<thead><tr><th>CompanyName</th><th>CompanyType</th><th>companyaddress</th><th>Actions</th></tr></thead><tbody>";

            $.each(companyData, function (index, company) {
                console.log('companyid', company.companyid)
                table += '<tr>';
                table += '<td>' + company.CompanyName + '</td>';
                table += '<td>' + company.companyType + '</td>';
                table += '<td>' + company.address + '</td>';
                table += '<td><a href="#" onclick="return getByIDCompany(' + company.companyid + ')">Edit</a> | <a href="#" onclick="DeleteCompany(' + company.companyid + ')">Delete</a></td>';
                table += '</tr>';
            });

            table += "</tbody>";

            //// Append the table to your HTML element
            //$('#yourTableID').html(table);

            ////var table = ''
            //$.each(companyData, function (index, company) {
            //    /*table += "<tr><td>" + company.CompanyName + "</td><td>" + company.companyType + "</td><td>" + company.address + "</td></tr>";*/
            //    table += '<tr><td>' + company.CompanyName + '</td><td> '+ company.companyType + '</td><td>' + company.address + '</td></tr>';

            //});
            ////table += "</tbody>";
            //console.log('company',table)
            ////console.log(tableHtml1)

            // Display the table on the webpage
            $("#companyTable").html(table);
        }


       
        function fetchCompanyNames() {
            let url = 'default.aspx/FetcCompanyList';
            $.ajax({
                url: url, 

                type: "POST",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    // Assuming the response is an array of company namessfs
                    var companyNameList = JSON.parse(response.d);
                    populateCompanyDropdown(companyNameList);
                },
                error: function (xhr, status, error) {
                    console.error('Error fetching company names:', error);
                    // Handle error
                }
            });
            return false;
        }

        // Function to populate company dropdown with fetched names
        function populateCompanyDropdown(companyNames) {
            var fetchedCompanyList = companyNames;
            
            companyList = fetchedCompanyList
            var companyNameListdropdown = $('#companyNameListdropdown');
            /*ddlCompanyType.empty();*/
            companyNameListdropdown.empty();
            companyNameListdropdown.append($('<option value="">Select Company Name</option>'));
            console.log('companylist', companyList)

            // Loop through the company names array and add options to the dropdown
            $.each(companyList, function (index, companyName) {
                companyNameListdropdown.append($('<option></option>').val(companyName.companyid).html(companyName.CompanyName));
                console.log(typeof companyName.CompanyName);
            });
        }


        
        function clearTextBox() {
          
            $('#FirstName').val("");
            $('#LastName').val("");
            $('#BirthDate').val("");
            $('#JoinDate').val("");
            $('#Designation').val("");
            $('#btnUpdate').hide();
            $('#btnAdd').show();
            $('#FirstName').css('border-color', 'lightgrey');
            $('#LastName').css('border-color', 'lightgrey');
            $('#BirthDate').css('border-color', 'lightgrey');
            $('#JoinDate').css('border-color', 'lightgrey');
            $('#Designation').css('border-color', 'lightgrey');
        }

        function clearTextBoxComp() {
            
            $('#CompanyName').val("");
            $('#address').val("");
            $('#companyTyp').val("");
            $('#CompanyName').css('border-color', 'lightgrey');
            $('#address').css('border-color', 'lightgrey');
            $('#companyType').css('border-color', 'lightgrey');
            
        }
    
    </script>
   

 <form id="form1" runat="server">
  <div class="container">
   <%-- <h2>Employees Record</h2>--%>
     <div id="employeeTableContainer">
     <h2 id="tableTitle">Employees Record</h2> 
    

    <table id="employeetable" class="table table-bordered table-hover">
      
        <tbody class="tbody">
            <!-- Employee records will be populated here -->
        </tbody>
    </table>
  </div>

<nav aria-label="Page navigation example" class="mt-2 d-flex">
<ul class="pagination Archive">
<%--<li class="page-item2" onclick="preClick()">--%>
<li class="page-item2" id="previousButton">
<a class="page-link" href="#" aria-label="Previous">
<span aria-hidden="true">&laquo;</span>
</a>
</li>
<div class="d-flex " id="list" >

</div>

<%--<li class="page-item2" onclick="nextClick()">--%>
<li class="page-item2" id="nextButton">
<a class="page-link" href="#" aria-label="Next">
<span aria-hidden="true">&raquo;</span>
</a>
</li>
</ul>
<select id="selectPage" class="form-select p-1 mx-3" aria-label=" " style="height:2.4rem; width: 6rem">

<option value="3">3</option>
<option value="5">5</option>
<option value="10">10</option>
</select>
</nav>


  
  
<div id="companyTableContainer" class="mt-2">
<h2 id="tableTitlecomany">Companies Record</h2> 
  <table id="companyTable" class="table table-bordered table-hover">
   
        <tbody>

        </tbody>
    </table>
    </div>
 </div>


  

  <%--<p class="container">
    <%--<h2>Employees Record</h2>--%>
    

<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
           
            <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center;">
                <h4 class="modal-title" id="myModalLabel">Add Employee</h4>
                <button type="button" class="close" data-dismiss="modal">×</button>
                
            </div>
            <div class="modal-body">
                <form>
                   
                    <div class="form-group">
                        <label for="FirstName">FirstName</label>
                        <input type="text" class="form-control" id="FirstName" placeholder="FirstName" />
                    </div>
                    <div class="form-group">
                   <label for="LastName">LastName</label>
                   <input type="text" class="form-control" id="LastName" placeholder="LastName" />
                   </div>
                    <div class="form-group">
                        <label for="BirthDate">BirthDate</label>
                        <input type="date" class="form-control" id="BirthDate" placeholder="YYYY-mm-dd" />
                    </div>
                    <div class="form-group">
                        <label for="JoinDate">JoinDate</label>
                        <input type="date" class="form-control" id="JoinDate" placeholder="YYYY-mm-dd" />
                    </div>
                    <div class="form-group">
                        <label for="Designation">Designation</label>
                        <input type="text" class="form-control" id="Designation" placeholder="Designation" />
                    </div>
                    <div class="form-group">
                    <label for="SelectCompany">Select Company</label>
                    <select class="form-control" id="companyNameListdropdown">
                    <option value="abc">Select Company</option>
                    </select>
                    </div>
                
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="btnAdd" onclick="Add();">Submit</button>
                <button type="button" class="btn btn-primary" id="btnUpdate" style="display: none;" onclick="Update();">Update</button>
                <button type="button" class="btn btn-primary" id="btnDelete" style="display: none;" onclick="Delete();">Delete</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="myCompany" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
           
            <div class="modal-header" style="display: flex; justify-content: space-between; align-items: center;">
                <h4 class="modal-title" id="myCompanyLabel">Add Company</h4>
                <button type="button" class="close" data-dismiss="modal">×</button>
                
            </div>
            <div class="modal-body">
                <form>
                   
                    <div class="form-group">
                        <label for="CompanyName">CompanyName</label>
                        <input type="text" class="form-control" id="CompanyName" placeholder="CompanyName" />
                    </div>
                    <div class="form-group">
                   <label for="address">address</label>
                   <input type="text" class="form-control" id="address" placeholder="address" />
                   </div>
                    <div class="form-group">
                        <label for="companyType">companyType</label>
                        <select class="form-control" id="companyType">
                          
                            <option value="">please select type</option>
                         </select>
                        <%--<input type="text" class="form-control" id="companyType" placeholder="Company Type" />--%>
                    </div>
                 </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" id="btnAddCompany" onclick="AddCompany();">Submit</button>
                <button type="button" class="btn btn-primary" id="btnUpdateCompany" style="display: none;" onclick="UpdateCompany();">Update</button>
                <button type="button" class="btn btn-primary" id="btnDeleteCompany" style="display: none;" onclick="DeleteCompany();">Delete</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>


  

<%--<nav aria-label="Page navigation example" class="mt-2 d-flex">
<ul class="pagination Archive">--%>
<%--<li class="page-item2" onclick="preClick()">--%>
<%--<li class="page-item2" id="previousButton">
<a class="page-link" href="#" aria-label="Previous">
<span aria-hidden="true">&laquo;</span>
</a>
</li>
<div class="d-flex " id="list" >

</div>--%>

<%--<%--<li class="page-item2" onclick="nextClick()">--%>
<%--<li class="page-item2" id="nextButton">
<a class="page-link" href="#" aria-label="Next">
<span aria-hidden="true">&raquo;</span>
</a>
</li>
</ul>
<select id="selectPage" class="form-select p-1 mx-3" aria-label=" " style="height:2.4rem; width: 6rem">

<option value="3">3</option>
<option value="5">5</option>
<option value="10">10</option>
</select>
</nav>--%>
<asp:HiddenField ID="currentPageHidden" runat="server" />
</form>



</body>
    
</html>



