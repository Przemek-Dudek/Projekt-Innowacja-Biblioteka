import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

<<<<<<< HEAD
import removePenalty from '@salesforce/apex/PersonUtils.removePenalty';
=======
import setPin from '@salesforce/apex/PersonUtils.removePenalty';
>>>>>>> 2fc7cbe (feat: Add removePenalty method to PersonUtils.cls and created penaltyManager LWC)

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
}