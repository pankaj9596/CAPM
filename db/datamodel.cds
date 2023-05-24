namespace com.db;

using { com.hr.commons } from './commons';

using
{
    cuid,
    temporal,
    Currency
}
from '@sap/cds/common';

context master
{
    entity employee
    {
        key EMPLOYEE_ID : commons.entityKeyId;
        FIRST_NAME : String;
        LAST_NAME : String;
        EMAIL_ID : String;
        AGE : Int16;
        GENDER : commons.Gender;
        CURRENCY : Currency;
        SALARY_AMOUNT : Decimal(10,2);
        ACCOUNT_NUMBER : String;
        BANK_NAME : String;
        IFSC_CODE : String;
        customer : Association to customer ;
    }

    entity customer 
    {
        key CUSTOMER_ID : commons.entityKeyId;
        SHIP_TO_ADDRESS : String;
        BILLING_ADDRESS : String;
        PHONE_NUMBER : commons.PhoneNumber;
        NOTES : String;
        ADDRESS : Association to address;
        DUMMY_ID : commons.entityKeyId;
        DUMMY_ID_2 : commons.entityKeyId;
        employee : Association to one employee on employee.customer = $self;
    }

    entity address
    {
        key ADDRESS_ID : commons.entityKeyId;
        HOUSE_NUMBER : String;
        ADDRESS_LINE_1 : String;
        POSTAL_CODE : Int16;
        CITY : String;
        COUNTRY_CODE : String;
        VALID_FROM : Date default $now;
        VALID_TO : Date default $now;
        customer : Association to one customer on  customer.ADDRESS = $self;
    }

    entity product
    {
        key PRODUCT_ID : commons.entityKeyId;
        COST : Decimal(10,2);
        CURRENCY : Currency;
        PRICE : Decimal(10,2);
        WIDTH : Decimal(10,2);
        WEIGHT : Decimal(10,2);
        WEIGHT_UNIT : String;
        SHORT_DESC : localized String;
        REMARKS : String;
    }
}

context transactional
{
    entity order 
    {
        key ORDER_ID : commons.entityKeyId;
        customer : Association to one master.customer;
        ORDER_ON : Date;
        DUE_DATE : Date;
        SHIP_METHOD : String;
        SHIPPING_REMARKS : String;
        ITEMS : Association to many orderitems on ITEMS.ORDER = $self;
    }

    entity orderitems : commons.Amount, cuid
    {
        ORDER : Association to one order;
        ITEM_ID : commons.entityKeyId;
        PRODUCT : Association to one master.product;
        QUANTITY : Int16;
    }

    entity invoice : commons.Amount, cuid
    {
        INVOICE_ID : commons.entityKeyId;
        ORDER_ID : Association to one order;
        DUE_DATE : Date;
        ITEMS : Association to many invoiceitems on ITEMS.INVOICE_ID = $self;
    }

    entity invoiceitems : cuid
    {
        ITEM_ID : commons.entityKeyId;
        INVOICE_ID : Association to one invoice;
    }
}
