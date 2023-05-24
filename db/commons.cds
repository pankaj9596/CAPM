namespace com.hr.commons;

using {Currency} from '@sap/cds/common';


type Gender      : String enum {
    male   = 'Male';
    female = 'Female';
};

type AmountT     : Decimal(10, 2) @(
    Semantics.amount.currencyCode: 'CURRENCY_CODE',
    sap.unit                     : 'CURRENCY_CODE'
);


aspect Amount : {
    CURRENCY     : Currency;
    GROSS_AMOUNT : AmountT;
    NET_AMOUNT   : AmountT;
    TAX_AMOUNT   : AmountT;
};

type entityKeyId : Integer;

type PhoneNumber : String(10)@assert.format : '^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$';

