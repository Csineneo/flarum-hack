<?php
namespace Flarum\Api;

use Tobscure\JsonApi\Document;
use Zend\Diactoros\Response\JsonResponse;

class JsonApiResponse extends JsonResponse {
  public function __construct(Document $document, $status = 200, array $headers = [], $encodingOptions = 15) {
    $headers['content-type'] = 'application/vnd.api+json';

    $lang="";
    if(isset($_SERVER["HTTP_ACCEPT_LANGUAGE"])) {
      preg_match('/^([a-z\-]+)/i', $_SERVER['HTTP_ACCEPT_LANGUAGE'], $matches);
      $lang = strtolower($matches[1]);
    }

    switch ($lang) {
      case "zh-cn":
      case "zh-sg":
        $ccconfig = opencc_open("t2s.json");
        break;
      case "zh-hk":
        $ccconfig = opencc_open("s2hk.json");
        break;
      case "zh-tw":
      case "zh":
        $ccconfig = opencc_open("s2tw.json");
        break;
      default:
        $ccconfig = "";
    }

    $cctext = opencc_convert(json_encode($document->jsonSerialize(), 256), $ccconfig);
    opencc_close($ccconfig);
    $ccconfig ? parent::__construct(json_decode($cctext), $status, $headers, $encodingOptions) : parent::__construct($document->jsonSerialize(), $status, $headers, $encodingOptions);
  }
}
