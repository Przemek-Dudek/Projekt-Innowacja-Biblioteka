import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import removePenalty from '@salesforce/apex/PersonUtils.removePenalty';
import getRentals from '@salesforce/apex/PersonUtils.getRentals';

export default class PenaltyManager extends LightningElement {
    @api recordId;
    
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

    @wire(getRentals, { personId: '$recordId' })
        getRentals({ error, data }) {
        if (data) {
            this.rentals = data.map(rental => ({
                label: rental.Id,
                value: rental.Overdue_Payment__c
            }));
        } else if (error) {
            console.log(error);
        }
    }
}