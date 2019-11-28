import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['display', 'source']

  connect() {
    this.wrapperClass = this.data.get('wrapperClass') || 'nested-fields';
  }

  recalc(event) {
    var total = 0.0;

    if(event.target.type === 'button') {
      const wrapper = event.target.closest('.' + this.wrapperClass);
      wrapper.querySelector('input[name*="percentage"]').value = 0.0;
    }

    this.sourceTargets.map(function(el) {
      if(el.value) {
        total += parseFloat(el.value);
      }
    });
    this.displayTarget.value = total;

    this.displayTarget.classList.remove('is-invalid');
    this.displayTarget.classList.remove('is-valid');

    if(total === 100.0) {
      this.displayTarget.classList.add('is-valid');
    } else if (total > 100.0) {
      this.displayTarget.classList.add('is-invalid');
    }
  }
}
