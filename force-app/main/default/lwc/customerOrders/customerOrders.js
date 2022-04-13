import { LightningElement, track, wire } from 'lwc';
import getAllCustomerOrder from '@salesforce/apex/JubilantFoodWorks.getAllCustomerOrders';


export default class CustomerOrders extends LightningElement {

    @track customerHaveOrders;
    @track customerId;
    @track _orderItemRef;
    @track allCOrders;

    @track ordersColumn = [{
        label: 'Order Number',
        fieldName: 'Name',
        type: 'text',
        sortable: true
    },
    {
        label: 'Status',
        fieldName: 'Status__c',
        type: 'text',
        sortable: true
    },
    {
        label: 'Payment Mode',
        fieldName: 'Payment_Mode__c',
        type: 'text',
        sortable: true
    },
    {
        label: 'Delivered On',
        fieldName: 'Delivered_On__c',
        type: 'Date',
        sortable: true
    }
];


    connectedCallback(){
        this.customerHaveOrders = true;
        this.customerId = 'a035h00000KgYbJAAV';
    }


    orderSomeProduct(){
        console.log('Order some item');
        const evt = new CustomEvent('addprod',{
            detail : 'true'
        });

        this.dispatchEvent(evt);
    }


    @wire(getAllCustomerOrder,{customerId : '$customerId'})
    orderItems(orders){
    const {data, error} = orders;
    this._orderItemRef = orders;

    if(data){
        console.log('allCus order' + JSON.stringify(data));
        this.allCOrders = data;
    } else if(error){
        console.log('Some Error in Customer Orders'+ error);
        }
    }
} 