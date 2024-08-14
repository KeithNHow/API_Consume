page 54000 "KNH Demo"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "KNH Demo";

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(Id; Rec.Id)
                {
                    ToolTip = 'Id';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Employee Name';
                }
                field("Employee Salary"; Rec."Employee Salary")
                {
                    ToolTip = 'Employee Salary';
                }
                field("Employee Age"; Rec."Employee Age")
                {
                    ToolTip = 'Employee Age';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GetRecords)
            {
                ApplicationArea = All;
                Caption = 'Get Records';
                Image = GetEntries;
                ToolTip = 'Get Records';

                trigger OnAction()
                var
                    APIManagement: Codeunit "KNH API Management";
                begin
                    APIManagement.GetRecords();
                end;
            }
            action(CreateRecords)
            {
                ApplicationArea = All;
                Caption = 'Create Records';
                Image = CreateDocuments;
                ToolTip = 'Create Records';

                trigger OnAction()
                var
                    APIManagement: Codeunit "KNH API Management";
                begin
                    APIManagement.CreateRecords();
                end;
            }
        }
        area(Promoted)
        {
            actionref(GetRecords_Ref; GetRecords) { }
            actionref(CreateRecords_Ref; CreateRecords) { }
        }
    }
}