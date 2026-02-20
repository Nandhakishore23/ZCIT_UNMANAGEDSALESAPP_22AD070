@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Interface View for the Items'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

define view entity ZCIT_SALES_ITEM_I_22AD70
  as select from zcit_item_22ad70
  association to parent ZCIT_SALES_I_22AD70 as _SalesHeader
    on $projection.SalesDocument = _SalesHeader.SalesDocument
{
  key salesdocument      as SalesDocument,
  key salesitemnumber    as SalesItemNumber,

      material           as Material,
      plant              as Plant,

  @Semantics.quantity.unitOfMeasure: 'QuantityUnits'
      quantity           as Quantity,

      quantityunits       as QuantityUnits,

  @Semantics.user.createdBy: true
      local_created_by   as LocalCreatedBy,

  @Semantics.systemDateTime.createdAt: true
      local_created_at   as LocalCreatedAt,

  @Semantics.user.lastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,

  @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

  /* Association */
  _SalesHeader
}
