*CLASS lhc_SalesOrderItm DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*
*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE SalesOrderItm.
*
*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE SalesOrderItm.
*
*    METHODS read FOR READ
*      IMPORTING keys FOR READ SalesOrderItm RESULT result.
*
*    METHODS rba_Salesheader FOR READ
*      IMPORTING keys_rba FOR READ SalesOrderItm\_Salesheader FULL result_requested RESULT result LINK association_links.
*
*ENDCLASS.
*
*CLASS lhc_SalesOrderItm IMPLEMENTATION.
*
*  METHOD update.
*  ENDMETHOD.
*
*  METHOD delete.
*  ENDMETHOD.
*
*  METHOD read.
*  ENDMETHOD.
*
*  METHOD rba_Salesheader.
*  ENDMETHOD.
*
*ENDCLASS.




CLASS lhc_SalesOrderItem DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS update
      FOR MODIFY
      IMPORTING entities FOR UPDATE SalesOrderItm.

    METHODS delete
      FOR MODIFY
      IMPORTING keys FOR DELETE SalesOrderItm.

    METHODS read
      FOR READ
      IMPORTING keys FOR READ SalesOrderItm
      RESULT result.

    METHODS rba_SalesHeader
      FOR READ
      IMPORTING keys_rba FOR READ SalesOrderItm\_SalesHeader
      FULL result_requested
      RESULT result
      LINK association_links.

ENDCLASS.



CLASS lhc_SalesOrderItem IMPLEMENTATION.

  METHOD update.

    DATA: ls_sales_itm TYPE ZCIT_ITEM_22AD70.

    LOOP AT entities INTO DATA(ls_entities).

      ls_sales_itm =
        CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).

      IF ls_sales_itm-salesdocument IS NOT INITIAL.

        SELECT *
          FROM ZCIT_ITEM_22AD70
          WHERE salesdocument   = @ls_sales_itm-salesdocument
            AND salesitemnumber = @ls_sales_itm-salesitemnumber
          INTO TABLE @DATA(lt_sales_itm).

        IF sy-subrc = 0.

          DATA(lo_util) = zcl_cit_util_22ad70=>get_instance( ).

          lo_util->set_itm_value(
            EXPORTING im_sales_itm = ls_sales_itm
            IMPORTING ex_created   = DATA(lv_created)
          ).

          IF lv_created = abap_true.

            APPEND VALUE #(
              salesdocument   = ls_sales_itm-salesdocument
              salesitemnumber = ls_sales_itm-salesitemnumber
            ) TO mapped-salesorderitm.

          ENDIF.

        ELSE.

          APPEND VALUE #(
            %cid = ls_entities-%cid_ref
            salesdocument   = ls_sales_itm-salesdocument
            salesitemnumber = ls_sales_itm-salesitemnumber
          ) TO failed-salesorderitm.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD delete.

    TYPES:
      BEGIN OF ty_sales_item,
        salesdocument   TYPE vbeln,
        salesitemnumber TYPE int2,
      END OF ty_sales_item.

    DATA ls_sales_itm TYPE ty_sales_item.

    DATA(lo_util) = zcl_cit_util_22ad70=>get_instance( ).

    LOOP AT keys INTO DATA(ls_key).

      CLEAR ls_sales_itm.

      ls_sales_itm-salesdocument   = ls_key-salesdocument.
      ls_sales_itm-salesitemnumber = ls_key-salesitemnumber.

      lo_util->set_itm_t_deletion(
        EXPORTING im_sales_itm_info = ls_sales_itm
      ).

    ENDLOOP.

  ENDMETHOD.



  METHOD read.
    " Optional
  ENDMETHOD.



  METHOD rba_SalesHeader.
    " Optional
  ENDMETHOD.

ENDCLASS.
