@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Interface View for the Header'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZCIT_SALES_I_22AD70
  as select from zcit_head_22ad70
  composition [0..*] of ZCIT_SALES_ITEM_I_22AD70 as _SalesItem
{
  key salesdocument          as SalesDocument,
      salesdocumenttype      as SalesDocumentType,
      orderreason            as OrderReason,
      salesorganization      as SalesOrganization,
      distributionchannel    as DistributionChannel,
      division               as Division,
      salesoffice            as SalesOffice,
      salesgroup             as SalesGroup,

  @Semantics.amount.currencyCode: 'Currency'
      netprice               as NetPrice,

      currency               as Currency,

  @Semantics.user.createdBy: true
      local_created_by       as LocalCreatedBy,

  @Semantics.systemDateTime.createdAt: true
      local_created_at       as LocalCreatedAt,

  @Semantics.user.lastChangedBy: true
      local_last_changed_by  as LocalLastChangedBy,

  @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at  as LocalLastChangedAt,

  /* Association */
  _SalesItem
}
