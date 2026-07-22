CLASS zcl_hello_world_gc DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_hello_world_gc IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    out->write( 'Olá, Mundo! Meu primeiro código ABAP Cloud no BTP!' ).

  ENDMETHOD.
ENDCLASS.
