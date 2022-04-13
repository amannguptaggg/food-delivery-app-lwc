import { api, LightningElement, track, wire } from 'lwc';
import pizzaImg from '@salesforce/resourceUrl/pizzaImg';
import cartItem from '@salesforce/apex/JubilantFoodWorks.getCartItem';
import deleteCartItem from '@salesforce/apex/JubilantFoodWorks.deleteCartItem';
import deleteAllCart from '@salesforce/apex/JubilantFoodWorks.deleteAllCartItems';


import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';


export default class AddToCart extends LightningElement {
  @track pizzaImg;
  @track cartItems;
  @track itemId;
  @track delid;
  @track isPopupOpen;
  @track itemData;
  @api addCartItem;
  @track addItemToCart;
  @track customerId;
  @api _cartData;
  @track totalCartSize;
  @track cartHaveItem;
  

    connectedCallback(){
        this.pizzaImg = pizzaImg;
        this.customerId = 'a035h00000KgYbJAAV';
        this.totalCartSize = 0;
        this.cartHaveItem = false;
    }

    @wire(cartItem,{customerId : '$customerId'})
    cartItm(cartResult){
        const {data, error} = cartResult;
        this._cartData = cartResult;
        if(data){
            console.log('cart item -> '+ JSON.stringify(data));
            this.cartItems = data;
            this.totalCartSize = data.length;
            
            if(this.totalCartSize > 0){
                this.cartHaveItem = true;
            }else{
                this.cartHaveItem = false;
            }

            //  event for total size 
            const evt = new CustomEvent('cartsize', {
                detail : this.totalCartSize
            });
            this.dispatchEvent(evt);
        }else if(error){
            console.log('error in cart item -> '+ error);
        }
    }


    
    @api refreshApexCartItem(event){
        console.log('event'+ event);
        if(this._cartData){
        console.log('refresh method from parent called');
        refreshApex(this._cartData);

        }
    }


    // view product open popup ; recieve item id
    viewProductFun(event){
        this.isPopupOpen = true;
        this.itemData =  event.currentTarget.dataset.itemid;
    }


    // remove cart item
    removeCartItem(event){
        event.preventDefault();
        this.delid =  event.currentTarget.dataset.delid;
        console.log('delete id => ' + this.delid);

        if(this.delid != null){
            console.log('custom id->' + this.customerId);
        deleteCartItem({itemId : this.delid, customerId: this.customerId})
        .then(result=>{
            console.log('deleted-> result -> ' + result);
            if(result){
                const event = new ShowToastEvent({
                    title : 'Item Removed From Cart',
                    variant: 'warning',
                    mode: 'dismissable'
               });
               this.dispatchEvent(event);
               refreshApex(this._cartData);
               console.log('refreshed');
            } else{
                const event = new ShowToastEvent({
                    title : 'Some Error in Removing Item',
                    variant: 'error',
                    mode: 'dismissable'
               });
               
               this.dispatchEvent(event);
                }
            })
        }

    }



       //delete all cart items
        deleteAllCartItems(event) {
            deleteAllCart({customerId: this.customerId})
            .then(result=>{
                console.log('deleted-> result -> ' + result);
                if(result){
                    const event = new ShowToastEvent({
                        title : 'Your Cart is Empty',
                        variant: 'warning',
                        mode: 'dismissable'
                   });
                   this.dispatchEvent(event);
                   refreshApex(this._cartData);
                   this.cartHaveItem = false;
                   console.log('refreshed');
                } else{
                    const event = new ShowToastEvent({
                        title : 'Some Error in Removing Item',
                        variant: 'error',
                        mode: 'dismissable'
                   });
                   this.dispatchEvent(event);
                    }
                })
        }


        addSomeProduct(){
            const evt = new CustomEvent('addprod',{
                detail : 'true'
            });

            this.dispatchEvent(evt);
        }


  


    // close model
    closeModel(event){
        this.isPopupOpen = false;
    };
}