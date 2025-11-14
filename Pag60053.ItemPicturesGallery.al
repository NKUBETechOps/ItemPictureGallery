page 60053 "Item Picture Gallery"
{
    Caption = 'Item Picture Gallery';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Item Picture Gallery";

    layout
    {
        area(content)
        {
            field(ImageCount; ImageCount)
            {
                ApplicationArea = All;
                ShowCaption = false;
                Editable = false;
            }
            field(Picture; Rec.Picture)
            {
                ApplicationArea = All;
                ShowCaption = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            fileuploadaction("Import Multiple")
            {
                ApplicationArea = All;
                Image = Import;
                AllowMultipleFiles = true;
                AllowedFileExtensions = '.jpg', '.jpeg';
                trigger OnAction(Files: List of [FileUpload])
                var
                    CurrentFile: FileUpload;
                    InStr: InStream;
                    FileName: Text;
                    FileMgt: Codeunit "File Management";
                    Item: Record Item;
                    ItemPictureGallery: Record "Item Picture Gallery";
                    PictureInStream: InStream;
                    FromFileName: Text;
                begin
                    FileName := '';
                    foreach CurrentFile in Files do begin
                        CurrentFile.CreateInStream(InStr, TextEncoding::MSDos);
                        FileName := FileMgt.GetFileNameWithoutExtension(CurrentFile.FileName);
                        if Item.Get(Rec."Item No.") then begin
                            ItemPictureGallery.Init();
                            ItemPictureGallery."Item No." := Item."No.";
                            ItemPictureGallery."Item Picture No." := FindLastItemPictureNo(ItemPictureGallery."Item No.") + 1;
                            ItemPictureGallery.Picture.ImportStream(InStr, FileName);
                            ItemPictureGallery."File Name" := FileName;
                            ItemPictureGallery.Insert();
                        end;
                    end;

                end;
            }

            action(Next)
            {
                ApplicationArea = All;
                Caption = 'Next';
                Image = NextRecord;

                trigger OnAction()
                begin
                    Rec.Next(1);
                end;
            }
            action(Previous)
            {
                ApplicationArea = All;
                Caption = 'Previous';
                Image = PreviousRecord;

                trigger OnAction()
                begin
                    Rec.Next(-1);
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    DeleteItemPicture;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        ItemPictureGallery: Record "Item Picture Gallery";
    begin
        ImageCount := '';
        ItemPictureGallery.Reset();
        ItemPictureGallery.SetRange("Item No.", Rec."Item No.");
        if ItemPictureGallery.Count > 0 then
            ImageCount := Format(ItemPictureGallery.Count)
        else
            ImageCount := '0';
    end;
    var
        ImageCount: Text[100];
    procedure DeleteItemPicture()
    var
        NothingDel: Label 'Nothing to delete';
    begin
        if Rec.Get(Rec."Item No.", Rec."Item Picture No.") then begin
            Clear(Rec.Picture);
            Rec.Delete();
        end else begin
            Message(NothingDel);
        end;
    end;

    local procedure FindLastItemPictureNo(ItemNo: Code[20]): Integer
    var
        ItemPictureGallery: Record "Item Picture Gallery";
    begin
        ItemPictureGallery.Reset();
        ItemPictureGallery.SetCurrentKey("Item No.", "Item Picture No.");
        ItemPictureGallery.Ascending(true);
        ItemPictureGallery.SetRange("Item No.", ItemNo);
        if ItemPictureGallery.FindLast() then
            exit(ItemPictureGallery."Item Picture No.");
    end;

}
