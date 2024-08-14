table 54000 "KNH Demo"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id';
        }
        field(2; "Employee Name"; Text[50])
        {
            Caption = 'Employee Name';
        }
        field(3; "Employee Salary"; Decimal)
        {
            Caption = 'Employee Salary';
        }
        field(4; "Employee Age"; Integer)
        {
            Caption = 'Employee Age';
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}