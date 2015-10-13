<?php echo get_component('default', 'updateCheck') ?>

<?php if ($sf_user->isAdministrator() && (string)QubitSetting::getByName('siteBaseUrl') === ''): ?>
  <div id="update-check">
    <?php echo link_to('Please configure your site base URL', 'settings/siteInformation', array('rel' => 'home', 'title' => __('Home'))) ?>
  </div>
<?php endif; ?>

<header id="top-bar">

  <?php if (sfConfig::get('app_toggleLogo')): ?>
    <?php echo link_to(image_tag('/plugins/arKbStylePlugin/images/kb_logo_white.svg'), '@homepage', array('class' => 'navbar-brand navbar-logo', 'id' => 'logo', 'rel' => 'home')) ?>
  <?php endif; ?>

  <?php if (sfConfig::get('app_toggleTitle')): ?>
    <h1 id="site-name">
      <?php echo link_to('<span>'.esc_specialchars(sfConfig::get('app_siteTitle')).'</span>', '@homepage', array('rel' => 'home', 'title' => __('Home'))) ?>
    </h1>
  <?php endif; ?>

  <nav>

    <?php echo get_component('menu', 'userMenu') ?>

    <?php echo get_component('menu', 'quickLinksMenu') ?>

    <?php echo get_component('menu', 'changeLanguageMenu') ?>

    <?php echo get_component('menu', 'mainMenu', array('sf_cache_key' => $sf_user->getCulture().$sf_user->getUserID())) ?>

  </nav>

  <div id="search-bar">

    <?php echo get_component('menu', 'browseMenu', array('sf_cache_key' => $sf_user->getCulture().$sf_user->getUserID())) ?>

    <?php echo get_component('search', 'box') ?>

  </div>

  </section>

  <?php echo get_component_slot('header') ?>

</header>

<?php if (sfConfig::get('app_toggleDescription')): ?>
  <div id="site-slogan">
    <div class="container">
      <div class="row">
        <div class="span12">
          <span><?php echo esc_specialchars(sfConfig::get('app_siteDescription')) ?></span>
        </div>
      </div>
    </div>
  </div>
<?php endif; ?>