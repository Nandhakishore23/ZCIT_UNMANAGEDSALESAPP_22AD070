*CLASS lhc_SalesOrderHdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
*  PRIVATE SECTION.
*
*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR SalesOrderHdr RESULT result.
*
*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      IMPORTING REQUEST requested_authorizations FOR SalesOrderHdr RESULT result.
*
*    METHODS create FOR MODIFY
*      IMPORTING entities FOR CREATE SalesOrderHdr.
*
*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE SalesOrderHdr.
*
*    METHODS delete FOR MODIFY
*      IMPORTING keys FOR DELETE SalesOrderHdr.
*
*    METHODS read FOR READ
*      IMPORTING keys FOR READ SalesOrderHdr RESULT result.
*
*    METHODS lock FOR LOCK
*      IMPORTING keys FOR LOCK SalesOrderHdr.
*
*    METHODS rba_Salesitem FOR READ
*      IMPORTING keys_rba FOR READ SalesOrderHdr\_Salesitem FULL result_requested RESULT result LINK association_links.
*
*    METHODS cba_Salesitem FOR MODIFY
*      IMPORTING entities_cba FOR CREATE SalesOrderHdr\_Salesitem.
*
*ENDCLASS.
*
*CLASS lhc_SalesOrderHdr IMPLEMENTATION.
*
*  METHOD get_instance_authorizations.
*  ENDMETHOD.
*
*  METHOD get_global_authorizations.
*  ENDMETHOD.
*
*  METHOD create.
*  ENDMETHOD.
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
*  METHOD lock.
*  ENDMETHOD.
*
*  METHOD rba_Salesitem.
*  ENDMETHOD.
*
*  METHOD cba_Salesitem.
*  ENDMETHOD.
*
*ENDCLASS.
*
*CLASS lsc_ZCIT_SALES_I_22AD70 DEFINITION INHERITING FROM cl_abap_behavior_saver.
*  PROTECTED SECTION.
*
*    METHODS finalize REDEFINITION.
*
*    METHODS check_before_save REDEFINITION.
*
*    METHODS save REDEFINITION.
*
*    METHODS cleanup REDEFINITION.
*
*    METHODS cleanup_finalize REDEFINITION.
*
*ENDCLASS.
*
*CLASS lsc_ZCIT_SALES_I_22AD70 IMPLEMENTATION.
*
*  METHOD finalize.
*  ENDMETHOD.
*
*  METHOD check_before_save.
*  ENDMETHOD.
*
*  METHOD save.
*  ENDMETHOD.
*
*  METHOD cleanup.
*  ENDMETHOD.
*
*  METHOD cleanup_finalize.
*  ENDMETHOD.
*
*ENDCLASS.


CLASS lhc_SalesOrderHdr DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations
      FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations
      FOR SalesOrderHdr RESULT result.

    METHODS get_global_authorizations
      FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations
      FOR SalesOrderHdr RESULT result.

    METHODS create
      FOR MODIFY
      IMPORTING entities FOR CREATE SalesOrderHdr.

    METHODS update
      FOR MODIFY
      IMPORTING entities FOR UPDATE SalesOrderHdr.

    METHODS delete
      FOR MODIFY
      IMPORTING keys FOR DELETE SalesOrderHdr.

    METHODS read
      FOR READ
      IMPORTING keys FOR READ SalesOrderHdr
      RESULT result.

    METHODS lock
      FOR LOCK
      IMPORTING keys FOR LOCK SalesOrderHdr.

    METHODS rba_SalesItem
      FOR READ
      IMPORTING keys_rba FOR READ SalesOrderHdr\_SalesItem
      FULL result_requested
      RESULT result
      LINK association_links.

    METHODS cba_SalesItem
      FOR MODIFY
      IMPORTING entities_cba FOR CREATE SalesOrderHdr\_SalesItem.

ENDCLASS.



CLASS lhc_SalesOrderHdr IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.


  METHOD create.

    DATA: ls_sales_hdr TYPE ZCIT_HEAD_22AD70.

    LOOP AT entities INTO DATA(ls_entities).

      ls_sales_hdr = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).

      IF ls_sales_hdr-salesdocument IS NOT INITIAL.

        SELECT SINGLE *
          FROM ZCIT_HEAD_22AD70
          WHERE salesdocument = @ls_sales_hdr-salesdocument
          INTO @DATA(ls_existing).

        IF sy-subrc <> 0.

          DATA(lo_util) = zcl_cit_util_22ad70=>get_instance( ).

          lo_util->set_hdr_value(
            EXPORTING im_sales_hdr = ls_sales_hdr
            IMPORTING ex_created   = DATA(lv_created)
          ).

          IF lv_created = abap_true.

            APPEND VALUE #(
              %cid = ls_entities-%cid
              salesdocument = ls_sales_hdr-salesdocument
            ) TO mapped-salesorderhdr.

          ENDIF.

        ELSE.

          APPEND VALUE #(
            %cid = ls_entities-%cid
            salesdocument = ls_sales_hdr-salesdocument
          ) TO failed-salesorderhdr.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD update.

    DATA: ls_sales_hdr TYPE ZCIT_HEAD_22AD70.

    LOOP AT entities INTO DATA(ls_entities).

      ls_sales_hdr = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).

      SELECT SINGLE *
        FROM ZCIT_HEAD_22AD70
        WHERE salesdocument = @ls_sales_hdr-salesdocument
        INTO @DATA(ls_existing).

      IF sy-subrc = 0.

        DATA(lo_util) = zcl_cit_util_22ad70=>get_instance( ).

        lo_util->set_hdr_value(
          EXPORTING im_sales_hdr = ls_sales_hdr
          IMPORTING ex_created   = DATA(lv_created)
        ).

        IF lv_created = abap_true.

          APPEND VALUE #(
            salesdocument = ls_sales_hdr-salesdocument
          ) TO mapped-salesorderhdr.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD delete.

    TYPES:
      BEGIN OF ty_sales_hdr,
        salesdocument TYPE vbeln,
      END OF ty_sales_hdr.

    DATA ls_sales_hdr TYPE ty_sales_hdr.

    DATA(lo_util) = zcl_cit_util_22ad70=>get_instance( ).

    LOOP AT keys INTO DATA(ls_key).

      ls_sales_hdr-salesdocument = ls_key-salesdocument.

      lo_util->set_hdr_t_deletion(
        EXPORTING im_sales_doc = ls_sales_hdr
      ).

      lo_util->set_hdr_deletion_flag(
        EXPORTING im_so_delete = abap_true
      ).

    ENDLOOP.

  ENDMETHOD.



  METHOD read.

    LOOP AT keys INTO DATA(ls_key).

      SELECT SINGLE *
        FROM ZCIT_HEAD_22AD70
        WHERE salesdocument = @ls_key-salesdocument
        INTO @DATA(ls_hdr).

      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_hdr ) TO result.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.



  METHOD rba_SalesItem.

    LOOP AT keys_rba INTO DATA(ls_key).

      SELECT *
        FROM ZCIT_ITEM_22AD70
        WHERE salesdocument = @ls_key-salesdocument
        INTO TABLE @DATA(lt_items).

      LOOP AT lt_items INTO DATA(ls_item).

        APPEND CORRESPONDING #( ls_item ) TO result.

        APPEND VALUE #(
          source-salesdocument = ls_key-salesdocument
          target-salesdocument = ls_item-salesdocument
          target-salesitemnumber = ls_item-salesitemnumber
        ) TO association_links.

      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.



  METHOD cba_SalesItem.

    DATA ls_sales_itm TYPE ZCIT_ITEM_22AD70.

    LOOP AT entities_cba INTO DATA(ls_entities_cba).

      ls_sales_itm =
        CORRESPONDING #( ls_entities_cba-%target[ 1 ] ).

      SELECT SINGLE *
        FROM ZCIT_ITEM_22AD70
        WHERE salesdocument   = @ls_sales_itm-salesdocument
        AND   salesitemnumber = @ls_sales_itm-salesitemnumber
        INTO @DATA(ls_existing).

      IF sy-subrc <> 0.

        DATA(lo_util) = zcl_cit_util_22ad70=>get_instance( ).

        lo_util->set_itm_value(
          EXPORTING im_sales_itm = ls_sales_itm
          IMPORTING ex_created   = DATA(lv_created)
        ).

        IF lv_created = abap_true.

          APPEND VALUE #(
            %cid = ls_entities_cba-%target[ 1 ]-%cid
            salesdocument   = ls_sales_itm-salesdocument
            salesitemnumber = ls_sales_itm-salesitemnumber
          ) TO mapped-salesorderitm.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.






CLASS lsc_ZCIT_SALES_I_22AD70 DEFINITION
  INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS finalize REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save REDEFINITION.
    METHODS cleanup REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.



CLASS lsc_ZCIT_SALES_I_22AD70 IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.


  METHOD check_before_save.
  ENDMETHOD.


  METHOD save.

    " Get buffer data
    DATA(lo_util) = zcl_cit_util_22ad70=>get_instance( ).

    lo_util->get_hdr_value(
      IMPORTING ex_sales_hdr = DATA(ls_sales_hdr)
    ).

    lo_util->get_itm_value(
      IMPORTING ex_sales_itm = DATA(ls_sales_itm)
    ).

    lo_util->get_hdr_t_deletion(
      IMPORTING ex_sales_docs = DATA(lt_sales_header)
    ).

    lo_util->get_itm_t_deletion(
      IMPORTING ex_sales_info = DATA(lt_sales_items)
    ).

    lo_util->get_deletion_flags(
      IMPORTING ex_so_hdr_del = DATA(lv_so_hdr_del)
    ).



    " 1️⃣ Save / Update Header
    IF ls_sales_hdr IS NOT INITIAL.
      MODIFY ZCIT_HEAD_22AD70 FROM @ls_sales_hdr.
    ENDIF.



    " 2️⃣ Save / Update Item
    IF ls_sales_itm IS NOT INITIAL.
      MODIFY ZCIT_ITEM_22AD70 FROM @ls_sales_itm.
    ENDIF.



    " 3️⃣ Handle Deletions
    IF lv_so_hdr_del = abap_true.

      LOOP AT lt_sales_header INTO DATA(ls_del_hdr).

        DELETE FROM ZCIT_HEAD_22AD70
          WHERE salesdocument = @ls_del_hdr-salesdocument.

        DELETE FROM ZCIT_ITEM_22AD70
          WHERE salesdocument = @ls_del_hdr-salesdocument.

      ENDLOOP.

    ELSE.

      LOOP AT lt_sales_header INTO ls_del_hdr.

        DELETE FROM ZCIT_HEAD_22AD70
          WHERE salesdocument = @ls_del_hdr-salesdocument.

      ENDLOOP.


      LOOP AT lt_sales_items INTO DATA(ls_del_itm).

        DELETE FROM ZCIT_ITEM_22AD70
          WHERE salesdocument   = @ls_del_itm-salesdocument
            AND salesitemnumber = @ls_del_itm-salesitemnumber.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.



  METHOD cleanup.
    zcl_cit_util_22ad70=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.


  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
