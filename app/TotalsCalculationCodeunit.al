codeunit 50211 "Purch Totals Calc"
{
    procedure UpdateTotals(
        DocumentType: Enum "Purchase Document Type";
        DocumentNo: Code[20];
        var LiveTotal: Decimal)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(LiveTotal);

        if DocumentNo = '' then
            exit;

        PurchaseLine.SetRange("Document Type", DocumentType);
        PurchaseLine.SetRange("Document No.", DocumentNo);
        PurchaseLine.SetFilter(Type, '<>%1', PurchaseLine.Type::" ");

        if PurchaseLine.FindSet() then
            repeat
                // Show a visible cross-check total based on the current document lines.
                LiveTotal += PurchaseLine."Line Amount";
            until PurchaseLine.Next() = 0;
    end;
}
