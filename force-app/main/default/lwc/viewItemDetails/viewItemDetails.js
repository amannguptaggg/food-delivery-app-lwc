import { api, LightningElement,track,wire } from 'lwc';
import item from '@salesforce/apex/JubilantFoodWorks.getItemUsingId';
import pizzaImg from '@salesforce/resourceUrl/pizzaImg';

export default class ViewItemDetails extends LightningElement {
    @api showDetails;
    @api items;
    @track singleFoodItem;
    @track pizzaImg;
    @track itemId;


    connectedCallback(){
        this.items = 'a055h00000ERSaMAAX';
        this.pizzaImg = pizzaImg;
    }

    // openModel(event){
    //     console.log('open child method called');

    //     const openM = event.detail;
    //     console.log('open M '+ openM);
    // }

    // get single food item
    @wire(item,{itemId : '$items'})
    itemData({data, error}){
        if(data){
            this.singleFoodItem = data;
            console.log('single item'+ data);
        } else if(error){
            console.log('some error in single item-> '+ error);
        } else {
            console.log('Unknown Error in child single item');
        } 
    }

    // cancle popup
    canclePopup(event){ 
        console.log('cancle called');
        this.showDetails = false;
        const evt = new CustomEvent('mclose', {
            detail : this.showDetails
        });

        this.dispatchEvent(evt);
    }

    addToCartFromPopup(event){
        this.itemId = event.currentTarget.dataset.itemid;
        console.log('add to cart called id -->'+ this.itemId);
        
        const evt = new CustomEvent('addcartfrompopup',{
            detail : this.itemId
        })

        this.dispatchEvent(evt);
    }

}