<?php

namespace FoF\Upload\Providers;

use FoF\Upload\Commands\DownloadHandler;
use FoF\Upload\Downloader\DefaultDownloader;
use FoF\Upload\Helpers\Settings;
use FoF\Upload\Templates\FileTemplate;
use FoF\Upload\Templates\ImagePreviewTemplate;
use FoF\Upload\Templates\ImageTemplate;
use FoF\Upload\Templates\AudioTemplate;
use FoF\Upload\Templates\VideoTemplate;
use FoF\Upload\Templates\TextTemplate;
use Flarum\Foundation\AbstractServiceProvider;

class DownloadProvider extends AbstractServiceProvider
{
    public function register()
    {
        DownloadHandler::addDownloader(
            $this->app->make(DefaultDownloader::class)
        );

        $this->loadViewsFrom(__DIR__ . '/../../resources/templates', 'fof-upload.templates');

        /** @var Settings $settings */
        $settings = $this->app->make(Settings::class);

        $settings->addRenderTemplate($this->app->make(FileTemplate::class));
        $settings->addRenderTemplate($this->app->make(ImageTemplate::class));
        $settings->addRenderTemplate($this->app->make(ImagePreviewTemplate::class));
        $settings->addRenderTemplate($this->app->make(AudioTemplate::class));
        $settings->addRenderTemplate($this->app->make(VideoTemplate::class));
        $settings->addRenderTemplate($this->app->make(TextTemplate::class));
    }
}
