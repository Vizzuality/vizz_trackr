import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['display', 'source']

  recalc() {
    var total = 0.0;
    this.sourceTargets.map(function(el) {
      total += parseFloat(el.value);
    });
    this.displayTarget.value = total;
  }
}
