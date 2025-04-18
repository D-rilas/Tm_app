"use client";

import { useState } from "react";
import { Document, Page, pdfjs } from 'react-pdf';
import 'react-pdf/dist/esm/Page/AnnotationLayer.css';
import 'react-pdf/dist/esm/Page/TextLayer.css';
pdfjs.GlobalWorkerOptions.workerSrc = `//unpkg.com/pdfjs-dist@${pdfjs.version}/build/pdf.worker.min.js`;
import { Button } from "@/components/ui/button";
import { Icons } from "@/components/icons";
import { Input } from "@/components/ui/input";

interface PDFViewerProps {
  pdfUrl: string;
}

export const PDFViewer: React.FC<PDFViewerProps> = ({ pdfUrl }) => {
  const [numPages, setNumPages] = useState<number | null>(null);
  const [pageNumber, setPageNumber] = useState(1);
  const [zoom, setZoom] = useState(1.0);
  const [searchQuery, setSearchQuery] = useState("");

  function onDocumentLoadSuccess({ numPages }: { numPages: number }) {
    setNumPages(numPages);
  }

  const goToPreviousPage = () => {
    setPageNumber((prevPageNumber) => Math.max(1, prevPageNumber - 1));
  };

  const goToNextPage = () => {
    setPageNumber((prevPageNumber) => Math.min(numPages || 1, prevPageNumber + 1));
  };

  const zoomIn = () => {
    setZoom((prevZoom) => Math.min(3, prevZoom + 0.2));
  };

  const zoomOut = () => {
    setZoom((prevZoom) => Math.max(0.5, prevZoom - 0.2));
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
  };

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <div className="flex items-center">
          <Button variant="outline" onClick={goToPreviousPage} disabled={pageNumber <= 1}>
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
          >
            Next
            <Icons.arrowRight className="ml-2 h-4 w-4" />
          </Button>
        </div>

        <div className="flex items-center">
          <Button variant="outline" onClick={zoomIn}>
            Zoom In
          </Button>
          <Button variant="outline" onClick={zoomOut}>
            Zoom Out
          </Button>
        </div>

        <Button variant="outline" onClick={downloadPdf}>
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

      <div style={{ overflow: 'auto' }}>
        <Document
          file={pdfUrl}
          onLoadSuccess={onDocumentLoadSuccess}
          className="border rounded shadow-md"
        >
          <Page pageNumber={pageNumber} scale={zoom} />
        </Document>
      </div>
    </div>
  );
};

