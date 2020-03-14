<?php

namespace Flagrow\Upload\Templates;

class ImageTemplate extends AbstractTemplate
{
    /**
     * @var string
     */
    protected $tag = 'image';

    /**
     * {@inheritdoc}
     */
    public function name()
    {
        return 'Images';
    }

    /**
     * {@inheritdoc}
     */
    public function description()
    {
        return 'Images';
    }

    /**
     * The xsl template to use with this tag.
     *
     * @return string
     */
    public function template()
    {
        return $this->getView('flagrow.download.templates::image');
    }

    /**
     * The bbcode to be parsed.
     *
     * @return string
     */
    public function bbcode()
    {
        return '[upl-image uuid={IDENTIFIER} size={SIMPLETEXT2} url={URL}]{SIMPLETEXT1}[/upl-image]';
    }
}
