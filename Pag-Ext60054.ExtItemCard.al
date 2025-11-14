pageextension 60054 "Ext-ItemCard" extends "Item Card"
{
    layout
    {
        modify(ItemPicture)
        {
            Visible=false;
        }
        addbefore(ItemPicture)
        {
            part(ItemPictureGall; "Item Picture Gallery")
            {
                ApplicationArea = All;
                SubPageLink = "Item No." = FIELD("No.");
            }
        }
    }
}
