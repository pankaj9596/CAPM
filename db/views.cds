namespace com.product;

using {
    com.db.master,
    com.db.transactional
} from './datamodel';


context customerviews {
    define view![Customer_To_Address] as 
        select from master.customer {
            key CUSTOMER_ID,
                BILLING_ADDRESS,
                PHONE_NUMBER,
                ADDRESS.CITY,
                ADDRESS.COUNTRY_CODE,
                ADDRESS.VALID_FROM,
                ADDRESS.VALID_TO
        };

    define view![PersonalProfile] as
        select from master.employee {
            key EMPLOYEE_ID,
            key customer.CUSTOMER_ID,
                FIRST_NAME,
                EMAIL_ID,
                BANK_NAME,
                ACCOUNT_NUMBER,
                IFSC_CODE,
                customer.BILLING_ADDRESS,
                customer.PHONE_NUMBER,
                customer.ADDRESS.CITY,
                customer.ADDRESS.COUNTRY_CODE,
                customer.ADDRESS.VALID_FROM,
                customer.ADDRESS.VALID_TO
        };

    define view![OrderDetails] as
        select from transactional.order {
            ORDER_ID,
            customer.CUSTOMER_ID,
            ORDER_ON,
            SHIP_METHOD,
            DUE_DATE,
            ITEMS.ITEM_ID,
            ITEMS.QUANTITY,
            ITEMS.PRODUCT.PRODUCT_ID,
            ITEMS.GROSS_AMOUNT,
            ITEMS.NET_AMOUNT,
            ITEMS.TAX_AMOUNT,
            ITEMS.CURRENCY as ORDERED_CURRENCY
        };

    define view![ProductView] as
        select from master.product
        mixin {
            PROD_ORDER : Association[ * ] to OrderDetails
                             on PROD_ORDER.PRODUCT_ID = $projection.PRODUCT_ID
        }
        into {
            PRODUCT_ID,
            SHORT_DESC as PROD_DESC,
            PRICE       as CP_Product,
            CURRENCY   as Curr_Product,
            WEIGHT,
            WIDTH,
            WEIGHT_UNIT,
            PROD_ORDER as ![To_Items]
        };


    define view CProductOrderDetails as
        select from ProductView {
            PRODUCT_ID,
            To_Items.SHIP_METHOD,
            sum(
                To_Items.GROSS_AMOUNT
            ) as![TotalAmount],
            To_Items.ORDERED_CURRENCY
        }
        group by
            PRODUCT_ID,
            To_Items.SHIP_METHOD,
            To_Items.ORDERED_CURRENCY;
}
