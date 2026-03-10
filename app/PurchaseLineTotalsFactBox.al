page 50110 "Purch Ln Totals FB"
{
    PageType = CardPart;
    SourceTable = "Purchase Header";
    ApplicationArea = All;
    Caption = 'Line Totals Check';
    Editable = false;

    layout
    {
        area(Content)
        {
            group(Totals)
            {
                ShowCaption = false;

                field(LiveTotal; LiveTotal)
                {
                    ApplicationArea = All;
                    Caption = 'Live Total Excl Tax';
                    AutoFormatType = 1;
                    ToolTip = 'Shows the summed line amount for the current purchase document.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        RefreshTotals();
    end;

    procedure RefreshFromHeader(PurchaseHeader: Record "Purchase Header")
    begin
        Rec := PurchaseHeader;
        RefreshTotals();
        CurrPage.Update(false);
    end;

    local procedure RefreshTotals()
    begin
        Clear(LiveTotal);

        if Rec."No." = '' then
            exit;

        TotalsCalc.UpdateTotals(
          Rec."Document Type",
          Rec."No.",
          LiveTotal);
    end;

    var
        TotalsCalc: Codeunit "Purch Totals Calc";
        LiveTotal: Decimal;
}
