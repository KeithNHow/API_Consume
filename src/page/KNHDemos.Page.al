page 54001 "KNH Demos"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "KNH Demo";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
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
        area(Factboxes)
        {

        }
    }
}