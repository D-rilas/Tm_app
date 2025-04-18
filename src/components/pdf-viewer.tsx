'use client';

import {useState, useEffect} from 'react';
import {Document, Page} from 'react-pdf';
import 'react-pdf/dist/esm/Page/AnnotationLayer.css';
import 'react-pdf/dist/esm/Page/TextLayer.css';

import {Button} from '@/components/ui/button';
import {Icons} from '@/components/icons';
import {Input} from '@/components/ui/input';

interface PDFViewerProps {
  pdfUrl: string;
}

export const PDFViewer: React.FC<PDFViewerProps> = ({pdfUrl}) => {
  const [numPages, setNumPages] = useState<number | null>(null);
  const [pageNumber, setPageNumber] = useState(1);
  const [zoom, setZoom] = useState(1.5);
  const [searchQuery, setSearchQuery] = useState('');

  useEffect(() => {
    setPageNumber(1);
    setZoom(1.5);
  }, [pdfUrl]);

  function onDocumentLoadSuccess({numPages}: {numPages: number}) {
    setNumPages(numPages);
  }

  const goToPreviousPage = () => {
    setPageNumber(prevPageNumber => Math.max(1, prevPageNumber - 1));
  };

  const goToNextPage = () => {
    setPageNumber(
      prevPageNumber => Math.min(numPages || 1, prevPageNumber + 1)
    );
  };

  const zoomIn = () => {
    setZoom(prevZoom => Math.min(3, prevZoom + 0.2));
  };

  const zoomOut = () => {
    setZoom(prevZoom => Math.max(0.5, prevZoom - 0.2));
  };

  const handleSearch = (event: React.ChangeEvent<HTMLInputElement>) => {
    setSearchQuery(event.target.value);
  };

  const downloadPdf = () => {
    const link = document.createElement('a');
    link.href = pdfUrl;
    link.download = 'document.pdf';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
  };

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center">
          <Button
            variant="outline"
            onClick={goToPreviousPage}
            disabled={pageNumber <= 1}
            className="p-4 mobile-button-size">
            <Icons.arrowRight className="mr-2 h-4 w-4 rotate-180" />
            Previous
          </Button>
          <span className="mx-2">
            Page {pageNumber} of {numPages}
          </span>
          <Button
            variant="outline"
            onClick={goToNextPage}
            disabled={pageNumber >= (numPages || 1)}
            className="p-4 mobile-button-size">
            Next
            <Icons.arrowRight className="ml-2 h-4 w-4" />
          </Button>
        </div>

        <div className="flex items-center">
          <Button variant="outline" onClick={zoomIn} className="p-4 mobile-button-size">
            Zoom In
          </Button>
          <Button variant="outline" onClick={zoomOut} className="p-4 mobile-button-size">
            Zoom Out
          </Button>
        </div>

        <Button variant="outline" onClick={downloadPdf} className="p-4 mobile-button-size">
          <Icons.arrowRight className="mr-2 h-4 w-4 rotate-90" />
          Download
        </Button>
      </div>

      <div className="mb-4">
        <Input
          type="text"
          placeholder="Search in document..."
          value={searchQuery}
          onChange={handleSearch}
        />
      </div>

      <div style={{overflow: 'auto'}}>
        <Document
          file={pdfUrl}
          onLoadSuccess={onDocumentLoadSuccess}
          className="border rounded shadow-md">
          <Page pageNumber={pageNumber} scale={zoom} />
        </Document>
      </div>
    </div>
  );
};
