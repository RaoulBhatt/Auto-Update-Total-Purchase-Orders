codeunit 50211 "Purch Totals Calc"
{
    procedure UpdateTotals(
        DocumentType: Enum "Purchase Document Type";
        DocumentNo: Code[20];
        var LiveTotal: Decimal;
        var LiveQtyToInvoiceTotal: Decimal)
    var
        PurchaseLine: Record "Purchase Line";
    begin
        Clear(LiveTotal);
        Clear(LiveQtyToInvoiceTotal);

        if DocumentNo = '' then
            exit;

        PurchaseLine.SetRange("Document Type", DocumentType);
        PurchaseLine.SetRange("Document No.", DocumentNo);
        PurchaseLine.SetFilter(Type, '<>%1', PurchaseLine.Type::" ");

        if PurchaseLine.FindSet() then
            repeat
                // Show a visible cross-check total based on the current document lines.
                LiveTotal += PurchaseLine."Line Amount";
                LiveQtyToInvoiceTotal += GetQtyToInvoiceAmount(PurchaseLine);
            until PurchaseLine.Next() = 0;
    end;

    local procedure GetQtyToInvoiceAmount(PurchaseLine: Record "Purchase Line"): Decimal
    begin
        if PurchaseLine.Quantity = 0 then
            exit(0);

        // Prorate the full line amount by the quantity currently marked to invoice.
        exit(Round(
          PurchaseLine."Line Amount" * PurchaseLine."Qty. to Invoice" / PurchaseLine.Quantity,
          0.01));
    end;
}
