codeunit 54000 "KNH API No Auth Management"
{
    procedure GetRecords()
    var
        Content: HttpContent;
        HttpMethod: Enum "Http Method";
        OutputString: Text;
        TargetUrlLbl: Label 'https://dummy.restapiexample.com/api/v1/create';
    begin
        KNHAPIRequestResponse.SetRequestHeaders(Content, '');
        OutputString := KNHAPIRequestResponse.CallApiEndpoint(Content, StrSubstNo(TargetUrlLbl), HttpMethod::GET);
        ParseJsonResponse(OutputString);
    end;

    procedure CreateRecords()
    var
        Content: HttpContent;
        HttpMethod: Enum "Http Method";
        OutputString: Text;
        TargetUrlLbl: Label 'https://dummy.restapiexample.com/api/v1/create';
    begin
        KNHAPIRequestResponse.SetRequestHeaders(Content, CreateEmployeeRecords());
        Outputstring := KNHAPIRequestResponse.CallApiEndpoint(Content, StrSubstNo(TargetUrlLbl), HttpMethod::POST);
        Message('%1', OutputString)
    end;

    procedure UpdateRecords(DemoData: Record "KNH Demo")
    var
        Content: HttpContent;
        HttpMethod: Enum "Http Method";
        OutputString: Text;
        TargetUrlLbl: Label 'https://dummy.restapiexample.com/api/v1/update/%1', Comment = '%1 = DemoData.Id';
    begin
        KNHAPIRequestResponse.SetRequestHeaders(Content, UpdateEmployeeRecords());
        OutputString := KNHAPIRequestResponse.CallApiEndpoint(Content, StrSubstNo(TargetUrlLbl, DemoData.Id), HttpMethod::PUT);
        Message('%1', OutputString);
    end;

    procedure DeleteRecords(DemoData: Record "KNH Demo")
    var
        Content: HttpContent;
        HttpMethod: Enum "Http Method";
        OutputString: Text;
        TargetUrlLbl: Label 'https://dummy.restapiexample.com/api/v1/delete/%1', Comment = '%1 = DemoData.Id';
    begin
        KNHAPIRequestResponse.SetRequestHeaders(Content, '');
        OutputString := KNHAPIRequestResponse.CallApiEndpoint(Content, StrSubstNo(TargetUrlLbl, DemoData.Id), HttpMethod::DELETE);
        Message('%1', OutputString)
    end;

    local procedure ParseJsonResponse(OutputString: Text)
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

            CreateRecordsInDemoTable(ResponseId, ResponseName, ResponseSalary, ResponseAge);
        end;
    end;

    local procedure CreateRecordsInDemoTable(ResponseId: Integer; ResponseName: Text[50]; ResponseSalary: Decimal; ResponseAge: Integer)
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

    local procedure CreateEmployeeRecords() NewRecord: Text
    var
        EmployeeRecord: JsonObject;
    begin
        EmployeeRecord.Add('employee_name', 'Fred');
        EmployeeRecord.Add('employee_salary', '45000');
        EmployeeRecord.Add('employee_age', '35');
        EmployeeRecord.WriteTo(NewRecord);
    end;

    local procedure UpdateEmployeeRecords() NewRecord: Text
    var
        EmployeeRecord: JsonObject;
    begin
        EmployeeRecord.Add('employee_name', 'John');
        EmployeeRecord.Add('employee_salary', '60000');
        EmployeeRecord.Add('employee_age', '55');
        EmployeeRecord.WriteTo(NewRecord);
    end;

    var
        KNHAPIRequestResponse: Codeunit "KNH API Request Response";
}