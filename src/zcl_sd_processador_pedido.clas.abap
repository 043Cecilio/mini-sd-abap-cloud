CLASS zcl_sd_processador_pedido DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_item_in,
        id_produto TYPE char10,
        quantidade TYPE i,
      END OF ty_item_in,
      tt_item_in TYPE STANDARD TABLE OF ty_item_in WITH EMPTY KEY.

    TYPES:
      BEGIN OF ty_resultado,
        sucesso       TYPE abap_bool,
        id_pedido     TYPE char10,
        valor_bruto   TYPE p LENGTH 15 DECIMALS 2,
        desconto      TYPE p LENGTH 15 DECIMALS 2,
        valor_liquido TYPE p LENGTH 15 DECIMALS 2,
        mensagem      TYPE string,
      END OF ty_resultado.

    METHODS criar_pedido
      IMPORTING
        iv_id_cliente TYPE char10
        it_itens      TYPE tt_item_in
      RETURNING
        VALUE(rs_resultado) TYPE ty_resultado.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_sd_processador_pedido IMPLEMENTATION.

  METHOD criar_pedido.

    " Validar se o Cliente existe e está ativo
    SELECT SINGLE * FROM zsd_cliente
      WHERE id_cliente = @iv_id_cliente
      INTO @DATA(ls_cliente).

    IF sy-subrc <> 0.
      rs_resultado = VALUE #( sucesso = abap_false mensagem = |Cliente { iv_id_cliente } não encontrado.| ).
      RETURN.
    ENDIF.

    IF ls_cliente-status <> 'A'.
      rs_resultado = VALUE #( sucesso = abap_false mensagem = |Cliente { ls_cliente-nome } está inativo.| ).
      RETURN.
    ENDIF.

    " Processar itens, validar estoque e calcular valor bruto
    DATA lt_items_db TYPE STANDARD TABLE OF zsd_pedido_itm.
    DATA lv_valor_bruto TYPE p LENGTH 15 DECIMALS 2 VALUE 0.
    DATA lv_item_num TYPE i VALUE 0.

    " Gerar ID do Pedido aleatório de 6 dígitos
    DATA(lv_id_pedido) = CONV char10( |PED{ cl_abap_random_int=>create( seed = cl_abap_random=>seed( ) min = 100000 max = 999999 )->get_next( ) }| ).

    LOOP AT it_itens INTO DATA(ls_item_in).

      SELECT SINGLE * FROM zsd_produto
        WHERE id_produto = @ls_item_in-id_produto
        INTO @DATA(ls_produto).

      IF sy-subrc <> 0.
        rs_resultado = VALUE #( sucesso = abap_false mensagem = |Produto { ls_item_in-id_produto } não encontrado.| ).
        RETURN.
      ENDIF.

      IF ls_produto-estoque < ls_item_in-quantidade.
        rs_resultado = VALUE #( sucesso = abap_false mensagem = |Estoque insuficiente para { ls_produto-descricao }. Disponível: { ls_produto-estoque }.| ).
        RETURN.
      ENDIF.

      lv_item_num += 10.
      DATA(lv_item_total) = CONV zsd_pedido_itm-valor_total( ls_item_in-quantidade * ls_produto-preco ).
      lv_valor_bruto += lv_item_total.

      APPEND VALUE zsd_pedido_itm(
        id_pedido   = lv_id_pedido
        item_pedido = lv_item_num
        id_produto  = ls_item_in-id_produto
        quantidade  = ls_item_in-quantidade
        preco_unit  = ls_produto-preco
        valor_total = lv_item_total
        moeda       = ls_produto-moeda
      ) TO lt_items_db.

    ENDLOOP.

    " Regra de Desconto Progressivo
    DATA lv_desconto_pct TYPE p LENGTH 5 DECIMALS 2.
    IF lv_valor_bruto >= 10000.
      lv_desconto_pct = '0.10'. " 10% de desconto
    ELSEIF lv_valor_bruto >= 5000.
      lv_desconto_pct = '0.05'. " 5% de desconto
    ELSE.
      lv_desconto_pct = '0.00'.
    ENDIF.

    DATA(lv_valor_desconto) = CONV zsd_pedido_cab-valor_desconto( lv_valor_bruto * lv_desconto_pct ).
    DATA(lv_valor_liquido)  = CONV zsd_pedido_cab-valor_total( lv_valor_bruto - lv_valor_desconto ).

    " Validar Limite de Crédito
    IF lv_valor_liquido > ls_cliente-limite_credito.
      rs_resultado = VALUE #(
        sucesso  = abap_false
        mensagem = |Limite de crédito excedido! Total do pedido ({ lv_valor_liquido } { ls_cliente-moeda }) ultrapassa o limite ({ ls_cliente-limite_credito } { ls_cliente-moeda }).|
      ).
      RETURN.
    ENDIF.

    " Gravar Cabeçalho e Itens no Banco de Dados
    DATA ls_cab TYPE zsd_pedido_cab.
    ls_cab-id_pedido      = lv_id_pedido.
    ls_cab-id_cliente     = iv_id_cliente.
    ls_cab-data_pedido    = sy-datum.
    ls_cab-valor_total    = lv_valor_liquido.
    ls_cab-valor_desconto = lv_valor_desconto.
    ls_cab-moeda          = ls_cliente-moeda.
    ls_cab-status_pedido  = 'C'. " Concluído

    INSERT zsd_pedido_cab FROM @ls_cab.
    INSERT zsd_pedido_itm FROM TABLE @lt_items_db.

    " Atualizar estoque dos produtos
    LOOP AT it_itens INTO ls_item_in.
      UPDATE zsd_produto
        SET estoque = estoque - @ls_item_in-quantidade
        WHERE id_produto = @ls_item_in-id_produto.
    ENDLOOP.

    rs_resultado = VALUE #(
      sucesso       = abap_true
      id_pedido     = lv_id_pedido
      valor_bruto   = lv_valor_bruto
      desconto      = lv_valor_desconto
      valor_liquido = lv_valor_liquido
      mensagem      = |Pedido { lv_id_pedido } criado com sucesso! Desconto de { lv_desconto_pct * 100 }% aplicado.|
    ).

  ENDMETHOD.

ENDCLASS.
