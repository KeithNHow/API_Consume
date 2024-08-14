codeunit 54000 "KNH API Management"
{
    procedure GetRecords()
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        OutputString: Text;
    begin
        Request.SetRequestUri('https://dummy.restapiexample.com/api/v1/employees'); //Endpoint for read
        Request.Method := 'Get'; //Gets or sets the method type as defined in the HTTP standard
        if Client.Send(Request, Response) then //Sends an HTTP request
            if Response.IsSuccessStatusCode() then begin
                Response.Content.ReadAs(OutputString); //Read content (json records) and place in text variable 
                ParseEmployeeResponse(OutputString);
            end else
                Message('Error: %1', Response.ReasonPhrase);
    end;

    procedure CreateRecords()
    var
        Client: HttpClient;
        Content: HttpContent;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
        OutputString: Text;
    begin
        Request.SetRequestUri('https://dummy.restapiexample.com/api/v1/create'); //Endpoint for create
        Request.Method := 'Post'; //Gets or sets the method type as defined in the HTTP standard
        Content.WriteFrom(CreateEmployeeRecords());
        if Client.Send(Request, Response) then //Sends an HTTP request
            if Response.IsSuccessStatusCode() then begin
                Response.Content.ReadAs(OutputString); //Read content (json records) and place in text variable 
                ParseEmployeeResponse(OutputString);
            end else
                Message('Error: %1', Response.ReasonPhrase);
    end;

    local procedure ParseEmployeeResponse(OutputString: Text)
    var
        EmployeeJson, EmployeeObject : JsonObject;
        StatusToken, EmployeeToken, EmployeesToken, ResultToken : JsonToken;
        EmployeeArray: JsonArray;
        ResponseName: Text[50];
        ResponseSalary: Decimal;
        ResponseId, ResponseAge : Integer;
    begin
        EmployeeJson.ReadFrom(OutputString); //Read from text variable and place in json object

        if EmployeeJson.Get('Status', StatusToken) then //Get status from json object and place in json token
            if StatusToken.AsValue().AsText() <> 'Success' then //Check if json token has text
                exit;

        if EmployeeJson.Get('data', EmployeesToken) then //Get data from json object and place in json token 
            if EmployeesToken.IsArray() then //if json token has multiple records
                EmployeeArray := EmployeesToken.AsArray(); //Convert json token to json array

        foreach EmployeeToken in EmployeeArray do begin //loop through records in json array

            EmployeeObject := EmployeesToken.AsObject(); //pass record from json object to another json object 

            EmployeeObject.Get('Id', ResultToken); //Get id field from json object and place in another json object
            ResponseId := ResultToken.AsValue().AsInteger(); //Convert id field in json object to integer variable

            EmployeeObject.Get('employee_name', ResultToken); //Get employee name field from json object and place in another json object
            ResponseName := CopyStr(ResultToken.AsValue().AsText(), 1, 50); //Convert employee name field in json object to text variable 

            EmployeeObject.Get('employee_salary', ResultToken); //Get employee salary field from json object and place in another json object
            ResponseSalary := ResultToken.AsValue().AsDecimal(); //Convert employee salary field in json object to decimal variable 

            EmployeeObject.Get('employee_age', ResultToken); //Get employee age field from json object and place in another json object
            ResponseAge := ResultToken.AsValue().AsInteger(); //Convert employee age field in json object to integer variable 

            WriteRecordsInTable(ResponseId, ResponseName, ResponseSalary, ResponseAge);
        end;
    end;

    local procedure WriteRecordsInTable(ResponseId: Integer; ResponseName: Text[50]; ResponseSalary: Decimal; ResponseAge: Integer)
    var
        KNHDemo: Record "KNH Demo";
    begin
        if ResponseId = 0 then
            exit;
        if KNHDemo.Get(ResponseId) then
            exit;
        KNHDemo.Init();
        KNHDemo.Validate(Id, ResponseId);
        KNHDemo.Validate("Employee Name", ResponseName);
        KNHDemo.Validate("Employee Salary", ResponseSalary);
        KNHDemo.Validate("Employee Age", ResponseAge);
        KNHDemo.Insert(true);

        ClearAll();
    end;

    procedure CreateEmployeeRecords() NewRecord: Text
    var
        EmployeeRecord: JsonObject;
    begin
        EmployeeRecord.Add('employee_name', 'Fred');
        EmployeeRecord.Add('employee_salary', '45000');
        EmployeeRecord.Add('employee_age', '35');
        EmployeeRecord.WriteTo(NewRecord);
        Message(NewRecord);
    end;
}