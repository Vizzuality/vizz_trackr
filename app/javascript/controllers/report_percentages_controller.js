import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['display', 'source']

  recalc() {
    var total = 0.0;
    this.sourceTargets.map(function(el) {
      if(el.value) {
        total += parseFloat(el.value);
      }
    });
    this.displayTarget.value = total;
  }
}
