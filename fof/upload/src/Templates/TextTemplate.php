<?php

namespace FoF\Upload\Templates;

class TextTemplate extends AbstractTemplate
{
    /**
     * @var string
     */
    protected $tag = 'text';

    /**
     * {@inheritdoc}
     */
    public function name()
    {
        return 'Text';
    }

    /**
     * {@inheritdoc}
     */
    public function description()
    {
        return 'Plain text Template';
    }

    /**
     * The xsl template to use with this tag.
     *
     * @return string
     */
    public function template()
    {
        return $this->getView('fof-upload.templates::text');
    }

    /**
     * The bbcode to be parsed.
     *
     * @return string
     */
    public function bbcode()
    {
        return '[upl-text uuid={IDENTIFIER} size={SIMPLETEXT2} url={URL}]{SIMPLETEXT1}[/upl-text]';
    }
}
