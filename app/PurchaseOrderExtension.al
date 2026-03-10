pageextension 50122 "Purch Ord Totals Ext" extends "Purchase Order"
{
    layout
    {
        addlast(FactBoxes)
        {
            part(LineTotals; "Purch Ln Totals FB")
            {
                ApplicationArea = All;
                SubPageLink = "Document Type" = field("Document Type"),
                              "No." = field("No.");
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        RefreshLineTotalsFactBox();
    end;

    local procedure RefreshLineTotalsFactBox()
    begin
        if Rec."No." = '' then
            exit;

        CurrPage.LineTotals.Page.RefreshFromHeader(Rec);
    end;
}

pageextension 50123 "Purch Ord Subf Ext" extends "Purchase Order Subform"
{
    layout
    {
        modify(Quantity)
        {
            trigger OnValidate()
            begin
                RefreshTotalsView(true);
            end;
        }

        modify("Direct Unit Cost")
        {
            trigger OnValidate()
            begin
                RefreshTotalsView(true);
            end;
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        RefreshTotalsView(false);
        exit(true);
    end;

    trigger OnModifyRecord(): Boolean
    begin
        RefreshTotalsView(false);
        exit(true);
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        RefreshTotalsView(false);
        exit(true);
    end;

    local procedure RefreshTotalsView(DoSave: Boolean)
    begin
        // Purchase lines use delayed insert, so saving after key field edits helps the FactBox update promptly.
        if DoSave and (Rec."Document No." <> '') then
            CurrPage.SaveRecord();

        CurrPage.Update(false);
    end;
}
