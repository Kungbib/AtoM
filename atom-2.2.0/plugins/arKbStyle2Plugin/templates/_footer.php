<footer class="footer">

  <?php if (QubitAcl::check('userInterface', 'translate')): ?>
    <?php echo get_component('sfTranslatePlugin', 'translate') ?>
  <?php endif; ?>

  <?php echo get_component_slot('footer') ?>

    <div class="footer-container">
      <div class="container">
        <div class="col-md-2 text-center">
          <?php echo image_tag('/plugins/arKbStyle2Plugin/images/kb_logo_black.svg') ?>
        </div>
        <div class="col-md-10 text-black">
          <p>
            <strong><a href="http://www.kb.se" alt="Länk till Kungl. bibliotekets webbplats">
              KUNGL. BIBLIOTEKET
            </a></strong>
            <br>
            <span>Support: <a href="mailto:test.test@kb.se">test.test@kb.se</a></span>
          </p>
        </div>
      </div>
    </div>
</footer>
