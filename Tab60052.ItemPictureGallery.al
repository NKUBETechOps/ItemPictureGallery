table 60052 "Item Picture Gallery"
{
    Caption = 'Item Picture Galley';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
            DataClassification = CustomerContent;
        }
        field(2; "Item Picture No."; Integer)
        {
            Caption = 'Item Picture No.';
            DataClassification = CustomerContent;
        }
        field(3; Picture; Media)
        {
            Caption = 'Picture';
            DataClassification = CustomerContent;
        }
        field(4; "File Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Item No.", "Item Picture No.")
        {
            Clustered = true;
        }
    }
}
