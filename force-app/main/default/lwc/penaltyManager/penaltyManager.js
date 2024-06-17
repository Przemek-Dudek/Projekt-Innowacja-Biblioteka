import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import removePenalty from '@salesforce/apex/PersonUtils.removePenalty';

export default class PenaltyManager extends LightningElement {
    @api recordId;

    @track items = [
        { id: 1, name: 'Książka 1', penalty: 10 },
        { id: 2, name: 'Książka 2', penalty: 20 },
        { id: 3, name: 'Książka 3', penalty: 0 },
        { id: 4, name: 'Inna ksiazka', penalty: 30 },
    ];

    handleReset(event) {
        const itemId = event.target.dataset.id;
        this.items = this.items.map(item => {
            if (item.id == itemId) {
                return { ...item, penalty: 0 };
            }
            return item;
        });
    }
    
    handleRemovePenalty() {
        removePenalty({ personId: this.recordId })
            .then(result => {
                const evt = new ShowToastEvent({
                    title: "Success",
                    message: "Penalty removed",
                    variant: "success",
                    });
                    this.dispatchEvent(evt);
                })
            .catch(error => {
                const evt = new ShowToastEvent({
                    title: "Error",
                    message: "Something went wrong",
                    variant: "error",
                    });
                    this.dispatchEvent(evt);
                });
    }

    // @wire(getRentals, { personId: '$recordId' })
    //     getRentals({ error, data }) {
    //     if (data) {
    //         this.rentals = data.map(rental => ({
    //             label: rental.Id,
    //             value: rental.Overdue_Payment__c
    //         }));
    //     } else if (error) {
    //         console.log(error);
    //     }
    // }
}