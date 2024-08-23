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
                    APIManagement: Codeunit "KNH API No Auth Management";
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
                    APIManagement: Codeunit "KNH API No Auth Management";
                begin
                    APIManagement.CreateRecords();
                end;
            }
            action(UpdateRecords)
            {
                ApplicationArea = All;
                Caption = 'Update Records';
                Image = UpdateDescription;
                ToolTip = 'Update Records';

                trigger OnAction()
                var
                    APIManagement: Codeunit "KNH API No Auth Management";
                begin
                    APIManagement.UpdateRecords(Rec);
                end;
            }
            action(DeleteRecords)
            {
                ApplicationArea = All;
                Caption = 'Delete Records';
                Image = DeleteRow;
                ToolTip = 'Delete Records';

                trigger OnAction()
                var
                    APIManagement: Codeunit "KNH API No Auth Management";
                begin
                    APIManagement.DeleteRecords(Rec);
                end;
            }
        }
        area(Promoted)
        {
            actionref(GetRecords_Ref; GetRecords) { }
            actionref(CreateRecords_Ref; CreateRecords) { }
            actionref(UpdateRecords_Ref; UpdateRecords) { }
            actionref(DeleteRecords_Ref; DeleteRecords) { }
        }
    }
}