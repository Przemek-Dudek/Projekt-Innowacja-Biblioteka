<<<<<<< HEAD
import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import setPin from '@salesforce/apex/PersonUtils.setPin';

export default class Pin extends LightningElement {
    @api recordId;
    
    handleGenerate() {
        setPin({ personId: this.recordId })
            .then(result => {
                const evt = new ShowToastEvent({
                    title: "Success",
                    message: "New Pin created",
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
=======
import { LightningElement } from 'lwc';

export default class Pin extends LightningElement {}
>>>>>>> a2691b9 (feat: Add Pin component and related files)
