CLASS zcl_sd_testar_pedidos DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_sd_testar_pedidos IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(lo_processador) = NEW zcl_sd_processador_pedido( ).

    " =====================================================================
    " CENÁRIO 1: Pedido Válido com Desconto de 10% (Valor > R$ 10.000)
    " =====================================================================
    out->write( '--- CENÁRIO 1: Pedido Válido (Beta Comércio - Limite 50k) ---' ).

    DATA lt_itens_1 TYPE zcl_sd_processador_pedido=>tt_item_in.
    lt_itens_1 = VALUE #(
      ( id_produto = 'PRD001' quantidade = 2 )  " 2x 4500 = 9.000
      ( id_produto = 'PRD002' quantidade = 3 )  " 3x 1200 = 3.600  (Total Bruto = 12.600)
    ).

    DATA(ls_res_1) = lo_processador->criar_pedido(
      iv_id_cliente = 'CLI002'
      it_itens      = lt_itens_1
    ).

    out->write( |Sucesso: { ls_res_1-sucesso }| ).
    out->write( |Mensagem: { ls_res_1-mensagem }| ).
    out->write( |Valor Bruto: R$ { ls_res_1-valor_bruto } | ).
    out->write( |Desconto Aplicado: R$ { ls_res_1-desconto }| ).
    out->write( |Valor Final do Pedido: R$ { ls_res_1-valor_liquido }| ).
    out->write( ' ' ).

    " =====================================================================
    " CENÁRIO 2: Pedido Recusado por Limite de Crédito Insuficiente
    " =====================================================================
    out->write( '--- CENÁRIO 2: Teste de Limite de Crédito (Gamma Tech - Limite 2k) ---' ).

    DATA lt_itens_2 TYPE zcl_sd_processador_pedido=>tt_item_in.
    lt_itens_2 = VALUE #(
      ( id_produto = 'PRD001' quantidade = 1 )  " 1x 4500 = 4.500 (Ultrapassa o limite de 2.000)
    ).

    DATA(ls_res_2) = lo_processador->criar_pedido(
      iv_id_cliente = 'CLI003'
      it_itens      = lt_itens_2
    ).

    out->write( |Sucesso: { ls_res_2-sucesso }| ).
    out->write( |Mensagem: { ls_res_2-mensagem }| ).
    out->write( ' ' ).

    " =====================================================================
    " CENÁRIO 3: Pedido Válido com Desconto de 5% (Empresa Alpha)
    " =====================================================================
    out->write( '--- CENÁRIO 3: Pedido Válido (Empresa Alpha - Limite 10k) ---' ).

    DATA lt_itens_3 TYPE zcl_sd_processador_pedido=>tt_item_in.
    lt_itens_3 = VALUE #(
      ( id_produto = 'PRD002' quantidade = 5 )  " 5x 1200 = 6.000 (Gera 5% de desconto)
    ).

    DATA(ls_res_3) = lo_processador->criar_pedido(
      iv_id_cliente = 'CLI001'
      it_itens      = lt_itens_3
    ).

    out->write( |Sucesso: { ls_res_3-sucesso }| ).
    out->write( |Mensagem: { ls_res_3-mensagem }| ).
    out->write( |Valor Liquido: R$ { ls_res_3-valor_liquido }| ).

  ENDMETHOD.

ENDCLASS.
