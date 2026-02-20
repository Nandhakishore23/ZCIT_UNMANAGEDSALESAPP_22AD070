@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Header Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity ZCIT_SALES_C_22AD70
  provider contract transactional_query
  as projection on ZCIT_SALES_I_22AD70
{
  key SalesDocument,
      SalesDocumentType,
      OrderReason,
      SalesOrganization,
      DistributionChannel,
      Division,

  @Search.defaultSearchElement: true
      SalesOffice,

      SalesGroup,

  @Semantics.amount.currencyCode: 'Currency'
      NetPrice,

      Currency,
      LocalCreatedBy,
      LocalCreatedAt,
      LocalLastChangedBy,
      LocalLastChangedAt,

  /* Associations */
  _SalesItem : redirected to composition child ZCIT_SALES_ITEM_C_22AD70
}
