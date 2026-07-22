CLASS zcl_sd_carga_dados DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_sd_carga_dados IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    " 1. Limpar registros antigos (para permitir re-execução)
    DELETE FROM zsd_cliente.
    DELETE FROM zsd_produto.

    " 2. Criar dados fictícios de Clientes
    DATA lt_clientes TYPE TABLE OF zsd_cliente.

    lt_clientes = VALUE #(
      ( id_cliente = 'CLI001' nome = 'Empresa Alpha Ltda'   limite_credito = '10000.00' moeda = 'BRL' status = 'A' )
      ( id_cliente = 'CLI002' nome = 'Beta Comércio S.A.'  limite_credito = '50000.00' moeda = 'BRL' status = 'A' )
      ( id_cliente = 'CLI003' nome = 'Gamma Tech Eireli'   limite_credito = '2000.00'  moeda = 'BRL' status = 'A' )
      ( id_cliente = 'CLI004' nome = 'Delta Logística'     limite_credito = '15000.00' moeda = 'BRL' status = 'I' )
    ).

    INSERT zsd_cliente FROM TABLE @lt_clientes.
    out->write( |Clientes inseridos: { sy-dbcnt }| ).

    " 3. Criar dados fictícios de Produtos
    DATA lt_produtos TYPE TABLE OF zsd_produto.

    lt_produtos = VALUE #(
      ( id_produto = 'PRD001' descricao = 'Notebook Dell Vostro'   preco = '4500.00' moeda = 'BRL' estoque = 50 )
      ( id_produto = 'PRD002' descricao = 'Monitor Dell 27"'       preco = '1200.00' moeda = 'BRL' estoque = 100 )
      ( id_produto = 'PRD003' descricao = 'Teclado Mecânico RGB'   preco = '350.00'  moeda = 'BRL' estoque = 200 )
      ( id_produto = 'PRD004' descricao = 'Mouse Sem Fio Erg'     preco = '150.00'  moeda = 'BRL' estoque = 150 )
      ( id_produto = 'PRD005' descricao = 'Cadeira Ergonômica'     preco = '950.00'  moeda = 'BRL' estoque = 30 )
    ).

    INSERT zsd_produto FROM TABLE @lt_produtos.
    out->write( |Produtos inseridos: { sy-dbcnt }| ).

    out->write( 'Carga de dados concluída com sucesso!' ).

  ENDMETHOD.

ENDCLASS.
