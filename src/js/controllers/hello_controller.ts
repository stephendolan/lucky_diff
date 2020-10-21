import { Controller } from "stimulus";

export default class extends Controller {
  connect(): void {
    console.log("StimulusJS is online!");
  }
}
