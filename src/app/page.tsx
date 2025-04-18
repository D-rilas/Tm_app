"use client";

import { useState, useEffect } from "react";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Icons } from "@/components/icons";
import { Button } from "@/components/ui/button";
import { PDFViewer } from "@/components/pdf-viewer";

interface PdfDocument {
  id: string;
  name: string;
  url: string;
  keywords: string[];
}

const pdfDocuments: PdfDocument[] = [
  {
    id: "1",
    name: "Sample PDF 1",
    url: "https://www.africau.edu/images/default/sample.pdf",
    keywords: ["sample", "document", "one"],
  },
  {
    id: "2",
    name: "Another PDF Example",
    url: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf",
    keywords: ["example", "pdf", "two"],
  },
];

export default function Home() {
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedPdf, setSelectedPdf] = useState<PdfDocument | null>(null);
  const [cachedPdfs, setCachedPdfs] = useState<string[]>([]);

  useEffect(() => {
    const storedCachedPdfs = localStorage.getItem('cachedPdfs');
    if (storedCachedPdfs) {
      setCachedPdfs(JSON.parse(storedCachedPdfs));
    }
  }, []);

  const filteredDocuments = pdfDocuments.filter((doc) => {
    const searchStr = searchTerm.toLowerCase();
    return (
      doc.name.toLowerCase().includes(searchStr) ||
      doc.keywords.some((keyword) => keyword.toLowerCase().includes(searchStr))
    );
  });

  const handlePdfSelect = (pdf: PdfDocument) => {
    setSelectedPdf(pdf);
  };

  const handleSearch = (event: React.ChangeEvent<HTMLInputElement>) => {
    setSearchTerm(event.target.value);
  };

  const isPdfCached = (url: string) => {
    return cachedPdfs.includes(url);
  };

  const handleDownload = async (pdf: PdfDocument) => {
    try {
      const response = await fetch(pdf.url);
      const blob = await response.blob();
      const url = URL.createObjectURL(blob);

      const a = document.createElement('a');
      a.href = url;
      a.download = pdf.name + '.pdf';
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);

      setCachedPdfs((prevCachedPdfs) => {
        const updatedCachedPdfs = [...prevCachedPdfs, pdf.url];
        localStorage.setItem('cachedPdfs', JSON.stringify(updatedCachedPdfs));
        return updatedCachedPdfs;
      });
    } catch (error) {
      console.error('Error downloading PDF:', error);
    }
  };

  return (
    <div className="container mx-auto py-8">
      <div className="mb-4 flex items-center">
        <Input
          type="text"
          placeholder="Search PDFs..."
          className="mr-2 w-full md:w-auto"
          value={searchTerm}
          onChange={handleSearch}
        />
        <Button variant="outline" className="bg-accent text-primary-foreground hover:bg-accent/80">
          <Icons.search className="mr-2 h-4 w-4" />
          Search
        </Button>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-8">
        {filteredDocuments.map((doc) => (
          <Card key={doc.id} onClick={() => handlePdfSelect(doc)} className="cursor-pointer">
            <CardHeader>
              <CardTitle>{doc.name}</CardTitle>
              <CardDescription>Keywords: {doc.keywords.join(", ")}</CardDescription>
            </CardHeader>
            <CardContent className="relative">
              <img
                src={`https://picsum.photos/200/150?random=${doc.id}`}
                alt={`Preview of ${doc.name}`}
                className="rounded-md"
              />
              <Button
                variant="secondary"
                size="icon"
                onClick={(e) => {
                  e.stopPropagation();
                  handleDownload(doc);
                }}
                className="absolute top-2 right-2 bg-accent text-primary-foreground hover:bg-accent/80"
                disabled={isPdfCached(doc.url)}
              >
                <Icons.download className="h-4 w-4" />
              </Button>
            </CardContent>
          </Card>
        ))}
      </div>

      {selectedPdf && (
        <div className="mt-8">
          <h2 className="text-2xl font-bold mb-4">{selectedPdf.name}</h2>
          <PDFViewer pdfUrl={selectedPdf.url} />
        </div>
      )}
    </div>
  );
}

