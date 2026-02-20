@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Item Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity ZCIT_SALES_ITEM_C_22AD70
  as projection on ZCIT_SALES_ITEM_I_22AD70
{
  key SalesDocument,
  key SalesItemNumber,

  @Search.defaultSearchElement: true
      Material,

      Plant,

  @Semantics.quantity.unitOfMeasure: 'QuantityUnits'
      Quantity,

      QuantityUnits,

      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,

  /* Associations */
  _SalesHeader : redirected to parent ZCIT_SALES_C_22AD70
}
