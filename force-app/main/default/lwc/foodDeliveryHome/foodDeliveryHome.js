import { LightningElement, track, wire,api } from 'lwc';
import allFoodItems from '@salesforce/apex/JubilantFoodWorks.allFoodItems';
import pizzaImg from '@salesforce/resourceUrl/pizzaImg';
import insertItemInCart from '@salesforce/apex/JubilantFoodWorks.addCartItem';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class FoodDeliveryHome extends LightningElement {

    @track allFoodItemsList;
    @track pizzaImg;
    @api isPopupOpen;
    @track itemData;
    @track foodItemsLayout;
    @track navData;
    @track cartItem;
    @track cartItemLayout;
    @track addToCartItemId;
    @track customerId;
    @track totalCartSize;
    @track itemIdfrompopup;

    connectedCallback(){
        this.pizzaImg = pizzaImg;
        this.foodItemsLayout = false;
        this.cartItemLayout = true;
        this.addToCartItemId = 'a055h00000ERSaMAAX';
        this.customerId = 'a035h00000KgYbJAAV';
        this.totalCartSize = 0;
    }

    // get all food items list
    @wire(allFoodItems)
    foods({data,error}){
        if(data){ 
            this.allFoodItemsList = data;
            console.log('food items -> ' +  this.allFoodItemsList);
        } else if(error){
            console.log('Some Error -> ' + error);
        }
    }


    showDetailsFn(event){
        event.preventDefault();
        console.log('showDetailsFn called');
        this.isPopupOpen = true;
        this.itemData = event.target.dataset.id;
        console.log('item->'+ event.target.dataset.id);
    }


    // close model
    closeModel(event){
        console.log('closeModelInParent -> '+ event.detail);
        this.isPopupOpen = false;
    };

    //  on cart size event

    totalCartSizeFn(event){
        console.log('cart size in parent on event rec' + event.detail );
        this.totalCartSize = event.detail;
    }


    // handle naviagations
    navHandler(e){
        e.preventDefault();
        this.navData = e.currentTarget.dataset.nav;
        console.log('navData --> '+ this.navData);

        if(this.navData == 'foodMenu'){
            this.foodItemsLayout = true;
            this.cartItemLayout = false;
        }

        if(this.navData == 'cart'){
            this.foodItemsLayout = false;
            this.cartItemLayout = true;
        }
    }


    // add to cart item
    addToCartItem(event){
        this.addToCartItemId = event.currentTarget.dataset.itemid;

        if(this.addToCartItemId != null || this.addToCartItemId != ''){
            insertItemInCart({itemId : this.addToCartItemId, customerId : this.customerId})
            .then(result=>{
                console.log('Add to cart result -> ' + result.Id);

            if(result.Id != null){
                const event = new ShowToastEvent({
                    title : 'Item Added To Cart',
                    variant: 'success',
                    mode: 'dismissable'
               });
               
               this.dispatchEvent(event);

               // refresh cart count
               
               try{

                let call = this.template.querySelector('c-add-to-cart').refreshApexCartItem();
                console.log(call);
               } catch(error){
                   console.log('error in refresh' + error);
               }

            } else {
                const event = new ShowToastEvent({
                    title : 'Some Error In Adding In Cart',
                    variant: 'error',
                    mode: 'dismissable'
               });
               this.dispatchEvent(event);
            }
            })
        }
    }


    // add to cart from popup

    addToCartFromPopup(event){
        this.itemIdfrompopup = event.detail;
        console.log('id got from popup ' + this.itemIdfrompopup);
    }

}