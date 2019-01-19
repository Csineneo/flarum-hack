<?php

/*
 * This file is part of Flarum.
 *
 * (c) Toby Zerner <toby.zerner@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Flarum\Locale;

use Flarum\Event\ConfigureLocales;
use Flarum\Foundation\AbstractServiceProvider;
use Flarum\Settings\SettingsRepositoryInterface;
use Illuminate\Contracts\Events\Dispatcher;
use Illuminate\Contracts\Translation\Translator as TranslatorContract;
use Symfony\Component\Translation\MessageSelector;
use Symfony\Component\Translation\TranslatorInterface;

class LocaleServiceProvider extends AbstractServiceProvider
{
    /**
     * {@inheritdoc}
     */
    public function boot(Dispatcher $events)
    {
        $locales = $this->app->make('flarum.locales');

// tofu        $locales->addLocale($this->getDefaultLocale(), 'Default');
		switch ($this->getDefaultLocale()) {
				case 'zh-hant':
					$locales->addLocale('zh-hant', '正體中文');
					break;
				case 'zh-hans':
					$locales->addLocale('zh-hans', '简体中文');
					break;
				default:
					$locales->addLocale('en', 'English');
		}

        $events->dispatch(new ConfigureLocales($locales));
    }

    /**
     * {@inheritdoc}
     */
    public function register()
    {
        $this->app->singleton(LocaleManager::class);
        $this->app->alias(LocaleManager::class, 'flarum.locales');

        $this->app->singleton('translator', function () {
            $translator = new Translator($this->getDefaultLocale(), new MessageSelector());
            $translator->setFallbackLocales(['en']);
            $translator->addLoader('prefixed_yaml', new PrefixedYamlFileLoader());

            return $translator;
        });
        $this->app->alias('translator', Translator::class);
        $this->app->alias('translator', TranslatorContract::class);
        $this->app->alias('translator', TranslatorInterface::class);
    }

    private function getDefaultLocale(): string
    {
				$lang="";
        if(isset($_SERVER['HTTP_ACCEPT_LANGUAGE'])) {
            preg_match('/^([a-z\-]+)/i', $_SERVER['HTTP_ACCEPT_LANGUAGE'], $matches);
            $lang = strtolower($matches[1]);
        }
        switch ($lang) {
            case 'zh-tw':
            case 'zh-hk':
            case 'zh':
                return 'zh-hant';
                break;
            case 'zh-cn':
            case 'zh-sg':
                return 'zh-hans';
                break;
            default:
								return 'en';
        }
    }
}
