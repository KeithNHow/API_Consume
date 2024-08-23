codeunit 54001 "KNH API Request Response"
{
    procedure SetRequestHeaders(var Content: HttpContent; EmployeeRecords: Text)
    var
        ContentHeaders: HttpHeaders;
    begin
        Content.GetHeaders(ContentHeaders);
        ContentHeaders.Clear();
        ContentHeaders.Add('Content-Type', 'application/json');
        if EmployeeRecords <> '' then
            Content.WriteFrom(EmployeeRecords);
    end;

    procedure CallApiEndpoint(Content: HttpContent; ApiEndpoint: Text; HttpMethod: Enum "Http Method") OutputString: Text
    var
        Client: HttpClient;
        Request: HttpRequestMessage;
        Response: HttpResponseMessage;
    begin
        Request.Content(Content);
        Request.SetRequestUri(ApiEndpoint);

        case HttpMethod of
            HttpMethod::GET:
                Request.Method('Get'); //Gets or sets the method type as defined in the HTTP standard
            HttpMethod::POST:
                Request.Method('Post');
            HttpMethod::PUT:
                Request.Method('Put');
            HttpMethod::DELETE:
                Request.Method('Delete');
        end;

        if Client.Send(Request, Response) then //Sends an HTTP request
            if Response.IsSuccessStatusCode() then
                Response.Content.ReadAs(OutputString) //Read content (json records) and place in text variable 
            else
                Message('Error: %1', Response.ReasonPhrase);
    end;
}